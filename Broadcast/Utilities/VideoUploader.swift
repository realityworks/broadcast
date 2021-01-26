//
//  VideoUploader.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/1/21.
//

import Foundation
import UIKit

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
class VideoUploader : NSObject, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDelegate {
    
    #warning("Need to move this over to use existing models")
    struct VideoDetails: Codable {
        let title: String
        let caption: String
        let videoCategoryIds: [String]
    }
    
    struct VideoUploadDetails: Decodable {
        let videoShortId: String
        let blobUrl: String
    }
    
    // MARK:- Callback Handlers
    var onProgressUpdate: ((Int64, Int64) -> Void)?
    var onComplete: (() -> Void)?
    var onFailure: ((Error) -> Void)?
    
    // MARK:- Internal properties
    #warning("Change to use dependency injection")
    private let apiService: APIService = Services.standard.apiService//DependencyInjection.defaultService
    
    /// File URL referecing the video we are currently uploading
    private var file: URL?
    
    /// Contains the details of the video file we will be uploading.
    private var videoDetails: VideoDetails?
    
    /// Structure returned to us to begin the streamed upload of a video to an endpoint
    private var videoUploadDetails: VideoUploadDetails?
    
    // Indicator once our upload total bytes matches required bytes
    private var finishedUploading: Bool = false
    
    /// You can only initialize a session once, in our video uploader case we need to make a singleton
    /// The URLSession itself behaves like a singleton.
    private let urlSessionConfiguration: URLSessionConfiguration
    private var urlSession: URLSession = URLSession(configuration: .default)
    
    private init(withSessionIdentifier sessionIdentifier: String) {
        
        /// Create our unique session configuration
        urlSessionConfiguration = .background(withIdentifier: sessionIdentifier)
        urlSessionConfiguration.sessionSendsLaunchEvents = true
        urlSessionConfiguration.shouldUseExtendedBackgroundIdleMode = true
        
        super.init()
        
        /// Not ideal, but in the private init, you cannot pass in a delegate to the initiliazer before all of self is initialized, hence the urlSession being initialized as a parameter
        /// Then initialized again here with a delegate.
        /// Here we create our base URLSession used for all video uploads in foreground and background.
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    /// Setup uploader
    /// - parameters:
    ///  - file: A url referencing the file that will be uploaded
    ///  - videoDetails: Contains meta data information about the video such as `Title` etc...
    func setup(from file: URL,
               videoDetails: VideoDetails) {
        
        Logger.log(level: .info, topic: .debug, message: "Setup upload")
        
        self.file = file
        self.videoDetails = videoDetails
    }
    
    /// Initiate the uploader.
    func start() {
        Logger.log(level: .info, topic: .debug, message: "Starting upload")
        
        guard let videoDetails = videoDetails else {
            self.onFailure?(VideoUploadError.notSetup)
            return
        }
        
        #warning("Use the correct API service")
//        apiService.getVideoUploadDetails(forVideoDetails: videoDetails) { [weak self] result in
//            log (message: "Received Upload details", .info)
//            guard let self = self else { return }
//            switch result {
//            case .success(let videoUploadDetails):
//                self.videoUploadDetails = videoUploadDetails
//                self.beginUpload(with: videoUploadDetails)
//            case .failure(let error):
//                self.onFailure?(error)
//            }
//        }
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

        if let error = error {
            onFailure?(VideoUploadError.networkError(error.localizedDescription))
        }
    }
    
    /// URL Session Delegate response function to handle when the uploader confirmed sending a certain amount of bytes up.
    /// This will be called up until all bytes have been uploaded
    @objc func urlSession(_ session: URLSession,
                          task: URLSessionTask,
                          didSendBodyData bytesSent: Int64,
                          totalBytesSent: Int64,
                          totalBytesExpectedToSend: Int64) {
        
        Logger.log(level: .info,
                   topic: .debug,
                   message: "Did send body data  BYTES SENT : \(bytesSent), TOTAL SENT : \(totalBytesSent), TOTAL EXPECTED TO SEND : \(totalBytesExpectedToSend)")
        
        /// Call the update handler with the number of bytes sent and bytes expected to send.
        onProgressUpdate?(totalBytesSent, totalBytesExpectedToSend)
        
        finishedUploading = totalBytesSent == totalBytesExpectedToSend
        if finishedUploading && UIApplication.shared.applicationState == .active {
            uploadCompletionHandler()
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
        
        Logger.log(level: .info,
                   topic: .debug,
                   message: "Did receive reply from server for upload task!")

        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        if httpResponse.statusCode == 201 {
            uploadCompletionHandler()
        } else {
            onFailure?(VideoUploadError.networkError("Error code : \(httpResponse.statusCode)"))
        }
    }
    
    @objc func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        Logger.log(level: .info,
                   topic: .debug,
                   message: "Background session has finished!")
        DispatchQueue.main.async { [unowned self] in
            #warning("Fix the background session completion")
//            guard let appDelegate: AppDelegate = AppDelegate.shared else { return }
//            appDelegate.backgroundSessionCompletion?()
            
            self.uploadCompletionHandler()
        }
    }
    
    // MARK:- Utility Functions
    
    func uploadCompletionHandler() {
        /// Local check here, do we need to do anything special here?
        guard let videoUploadDetails = videoUploadDetails else {
            /// There were no video upload details set, we cannot close this upload
            onFailure?(VideoUploadError.noUploadDetails)
            return
        }
        
        Logger.log(level: .info, topic: .debug, message: "Upload Completed! Confirming with API Service")
        
        urlSession.flush {
            Logger.log(level: .info, topic: .debug, message: "Flushed the background upload")
        }
        
        /// Confirm that the upload completed. Once this returns we are safe to say the video has completed the upload successfully.
        #warning("Perhaps just use self.onComplete?() and remove this, along with any API Service calls, use this just for the upload")
//        apiService.confirmCompleteUpload(forUploadDetails: videoUploadDetails) { [weak self] result in
//            guard let self = self else { return }
//            log(message: "Confirm upload complete with result : \(result)", .info)
//
//            switch result {
//            case .success:
//                self.onComplete?()
//            case .failure(let error):
//                self.onFailure?(error)
//            }
//
//            /// Mark our background task completed if this was done in the background
//            if let backgroundCompletionTaskIdentifier = self.backgroundCompletionTaskIdentifier  {
//                UIApplication.shared.endBackgroundTask(backgroundCompletionTaskIdentifier)
//            }
//        }
    }
    
    /// Begins an upload task when the video details of our upload have been passed from the API.
    /// The upload task is prepared with the correct parameters required for the file upload and new sessions kicks of an upload task.
    /// - parameters: videoDetails contains the endpoint upload URL used to upload our video
    private func beginUpload(with videoUploadDetails: VideoUploadDetails) {
        Logger.log(level: .info, topic: .debug, message: "Begin Upload with : \(videoUploadDetails)")
        
        guard let file = file else {
            onFailure?(VideoUploadError.notSetup)
            return
        }
        #warning("Get the right info for this call when doing the uploadService")
        /// Use our global background session configuration since we only allow one
        var request = URLRequest(url: URL(string: videoUploadDetails.blobUrl)!)
        request.httpMethod = "PUT"
        
        // Need to add custom http header fields?
        let fileSize = 0//FileManager.default.sizeOfFile(atPath: file.path)!
        
        request.addValue("BlockBlob", forHTTPHeaderField: "x-ms-blob-type")
        request.addValue("\(fileSize)", forHTTPHeaderField: "Content-Length")
        
        let uploadTask = urlSession.uploadTask(with: request, fromFile: file)
        uploadTask.resume()
    }
}
