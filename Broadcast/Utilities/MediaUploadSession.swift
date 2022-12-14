//
//  MediaUploadSession.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/1/21.
//

import UIKit
import BackgroundTasks

enum VideoUploadError : Error {
    case networkError(String)
    case noUploadDetails
    case notSetup
}

/// Video uploader object, allows a file with meta data to be uploaded to an endpoint as defined within the API constraints
/// of Azure Blob uploaders.
/// A request to upload the video is created from our meta data, which returns the URL where we will upload the video data to.
/// Once the video data is uploaded, the session will receive a completion (one for background, one for foreground) and needs
/// to finalise the upload by calling an endpoint with our video id to close the upload.
class MediaUploadSession : NSObject,
                           URLSessionTaskDelegate,
                           URLSessionDataDelegate,
                           URLSessionDelegate {
    
    // MARK:- Callback Handlers
    private var onProgressUpdate: ((Int64, Int64) -> Void)?
    private var onComplete: (() -> Void)?
    private var onFailure: ((Error) -> Void)?
    
    // MARK:- Internal properties
    
    /// File URL referecing the video we are currently uploading
    private var from: URL?
    private var to: URL?
    
    // Indicator once our upload total bytes matches required bytes
    private var finishedUploading: Bool = false
    
    /// You can only initialize a session once, in our video uploader case we need to make a singleton
    /// The URLSession itself behaves like a singleton.
    private var urlSession: URLSession!
    private weak var uploadTask: URLSessionUploadTask?
    
    init(withIdentifier sessionIdentifier: String) {
        /// Create our unique session configuration
        
        super.init()
        
        let backgroundSessionConfiguration = URLSessionConfiguration.background(withIdentifier: sessionIdentifier)
        backgroundSessionConfiguration.sessionSendsLaunchEvents = true
        backgroundSessionConfiguration.isDiscretionary = false
        backgroundSessionConfiguration.shouldUseExtendedBackgroundIdleMode = true
        
        /// Not ideal, but in the private init, you cannot pass in a delegate to the initiliazer before all of self is initialized, hence the urlSession being initialized as a parameter
        /// Then initialized again here with a delegate.
        /// Here we create our base URLSession used for all video uploads in foreground and background.
        urlSession = URLSession(configuration: backgroundSessionConfiguration,
                                delegate: self,
                                delegateQueue: nil)
    }
    
    /// Initiate the uploader.
    func start(from: URL,
               to: URL,
               onProgressUpdate: ((Int64, Int64) -> Void)? = nil,
               onComplete: (() -> Void)? = nil,
               onFailure: ((Error) -> Void)? = nil) {
        Logger.log(level: .info, topic: .debug, message: "Starting upload with session config : \(urlSession.configuration)")
        
        self.from = from
        self.to = to
        self.onProgressUpdate = onProgressUpdate
        self.onComplete = onComplete
        self.onFailure = onFailure
        
        finishedUploading = false
        
        prepareUpload()
    }
    
    // MARK:- URLSessionDelegate

    /// URL Session Delegate response function to handle an error state during our session
    /// This call is also received when the task did complete in the background without an error.
    /// In this case we need to check for `Error` and only fail if the error exists. Otherwise it's likely this call indicates a background
    /// upload is successful.
    @objc func urlSession(_ session: URLSession,
                          task: URLSessionTask,
                          didCompleteWithError error: Error?) {
        
        Logger.log(level: .info,
                   topic: .debug,
                   message: "Task did complete with error : \(error?.localizedDescription ?? "No error provided")")
        
        guard task.taskIdentifier == uploadTask?.taskIdentifier else {
            Logger.log(level: .warning,
                       topic: .debug,
                       message: "SessionTask: \(task.taskIdentifier) needs to be \(uploadTask?.taskIdentifier)")
            return
        }

        if let error = error {
            failureHandler(error: VideoUploadError.networkError(error.localizedDescription))
            return
        }
        
        Logger.warning(topic: .api, message: "Task - \(task)")
        if let httpResponse = task.response as? HTTPURLResponse {
            Logger.warning(topic: .api, message: "StatusCode - \(httpResponse.statusCode)")
            if httpResponse.statusCode != 201 {
                failureHandler(error: VideoUploadError.networkError("Error code : \(httpResponse.statusCode)"))
                return
            }
        }
        
        // Check lost connection
        DispatchQueue.main.async { [unowned self] in
            if !finishedUploading && UIApplication.shared.applicationState == .active {
                failureHandler(error: VideoUploadError.networkError("Lost connection to the service. Please try uploading again."))
                return
            }
        }
    }
    
    /// URL Session Delegate response function to handle when the uploader confirmed sending a certain amount of bytes up.
    /// This will be called up until all bytes have been uploaded
    @objc func urlSession(_ session: URLSession,
                          task: URLSessionTask,
                          didSendBodyData bytesSent: Int64,
                          totalBytesSent: Int64,
                          totalBytesExpectedToSend: Int64) {
        
        guard task.taskIdentifier == uploadTask?.taskIdentifier else {
            Logger.log(level: .warning,
                       topic: .debug,
                       message: "SessionTask: \(task.taskIdentifier) needs to be \(uploadTask?.taskIdentifier)")
            task.cancel()
            failureHandler(error: VideoUploadError.networkError("Upload task failed due to delays"))
            return
        }
        
        Logger.log(level: .info,
                   topic: .debug,
                   message: "SessionTask: \(task.taskIdentifier) : Did send body data - BYTES SENT : \(bytesSent), TOTAL SENT : \(totalBytesSent), TOTAL EXPECTED TO SEND : \(totalBytesExpectedToSend)")
        
        /// Call the update handler with the number of bytes sent and bytes expected to send.
        DispatchQueue.main.async { [weak self] in
            self?.onProgressUpdate?(totalBytesSent, totalBytesExpectedToSend)
        }
        
        if totalBytesSent == totalBytesExpectedToSend {
            Logger.log(level: .info, topic: .api, message: "Completed upload with bytes uploaded comparison")
                self.uploadCompletionHandler()
        }
    }
    
    // MARK:- URLSessionDataDelegate

    /// URL Session delegate response when receiving the completion handler in the foreground.
    /// This will be called when a data task has received a final response from the upload task. It will only be called if the stream
    /// is running when the app is in the forground. Background calls will be handled by the background task completion.
    @objc func urlSession(_ session: URLSession,
                          dataTask: URLSessionDataTask,
                          didReceive response: URLResponse,
                          completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard dataTask.taskIdentifier == uploadTask?.taskIdentifier else {
            Logger.log(level: .warning,
                       topic: .debug,
                       message: "SessionTask: \(dataTask.taskIdentifier) needs to be \(uploadTask?.taskIdentifier)")
            dataTask.cancel()
            failureHandler(error: VideoUploadError.networkError("Upload task failed due to delays"))
            return
        }
        
        Logger.log(level: .info,
                   topic: .debug,
                   message: "Did receive reply from server for upload task!")

        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        if httpResponse.statusCode == 201 {
            uploadCompletionHandler()
        } else {
            failureHandler(error: VideoUploadError.networkError("Error code : \(httpResponse.statusCode)"))
        }
    }
    
    @objc func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        Logger.log(level: .info,
                   topic: .debug,
                   message: "Background session has finished!")
        
        DispatchQueue.main.async { [unowned self] in
            guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate,
                  let identifier = session.configuration.identifier
            else {
                self.failureHandler(error: BoomdayError.internalMemoryError(text: "Unable to complete background upload properly, may have failed."))
                return
            }
            
            appDelegate.backgroundSessionCompletion[identifier]?()
            self.uploadCompletionHandler()
        }
    }
    
    // MARK:- Utility Functions
    
    func refresh() {
        uploadTask?.suspend()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            self.uploadTask?.resume()
        })
    }
    
    private func failureHandler(error: Error) {
        Logger.log(level: .warning, topic: .debug, message: error.localizedDescription)
        uploadTask?.cancel()
        
        DispatchQueue.main.async { [weak self] in
            self?.onFailure?(error)
        }
    }
    
    private func uploadCompletionHandler() {
        Logger.log(level: .info, topic: .debug, message: "Upload Completed! Confirming with API Service")
        
        finishedUploading = true
        
        urlSession.flush {
            Logger.log(level: .info, topic: .debug, message: "Flushed the background upload")
        }
                
        /// On complete and res
        DispatchQueue.main.async { [weak self] in
            self?.onComplete?()
        }
    }
    
    /// Begins an upload task when the video details of our upload have been passed from the API.
    /// The upload task is prepared with the correct parameters required for the file upload and new sessions kicks of an upload task.
    /// - parameters: videoDetails contains the endpoint upload URL used to upload our video
    private func prepareUpload() {
        Logger.log(level: .info, topic: .debug, message: "Begin Upload")
        
        guard let from = from,
              let to = to else {
            failureHandler(error: VideoUploadError.noUploadDetails)
            return
        }
        
        urlSession.getAllTasks { [self] allTasks in
            // Cancel all outstanding tasks!
            allTasks.forEach { $0.cancel() }
            beginUpload(from: from, to: to)
        }
    }
    
    private func beginUpload(from: URL, to: URL) {
        urlSession.reset { [self] in
            /// Use our global background session configuration since we only allow one
            var request = URLRequest(url: to)
            request.httpMethod = "PUT"
            
            // Need to add custom http header fields?
            let fileSize = from.fileSize()!
            
            request.addValue("BlockBlob", forHTTPHeaderField: "x-ms-blob-type")
            request.addValue("\(fileSize)", forHTTPHeaderField: "Content-Length")
            request.timeoutInterval = TimeInterval(60)
            
            uploadTask = urlSession.uploadTask(with: request, fromFile: from)
            uploadTask?.priority = URLSessionTask.highPriority
            uploadTask?.resume()
            
            Logger.info(topic: .api, message: "Starting upload task : \(uploadTask?.taskIdentifier)")
        }
    }
}
