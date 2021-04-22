//
//  StandardAPIService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit
import Network
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

typealias APIParameters = Dictionary<String, String>
typealias Headers = Dictionary<String, String>

class StandardAPIService : RequestInterceptor {
    
    fileprivate let baseUrl: URL
    fileprivate let session: Session
    fileprivate var backgroundSession: URLSession!
    fileprivate let schedulers: Schedulers
    
    var credentialsService: CredentialsService?
    
    typealias DataTaskError = ((Error)->())
    typealias DataTaskComplete = ((HTTPURLResponse, Data)->())
    
    struct DataTaskHandler {
        let onError: DataTaskError
        let onComplete: DataTaskComplete
    }
    
    var dataTaskHandlers: Dictionary<Int, DataTaskHandler> = [:]
    var dataTaskResponse: Dictionary<Int, Data> = [:]
    
    private let validStatusCodes = [Int](200 ..< 300) + [400, 403, 404, 409, 500, 503, 504, 511, 512, 513]
    
    init(dependencies: Dependencies = .standard) {
        self.baseUrl = dependencies.baseUrl
        self.schedulers = dependencies.schedulers
        self.session = Session.default
        self.credentialsService = nil
                
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.waitsForConnectivity = true
        //urlSessionConfiguration.sessionSendsLaunchEvents = true
        urlSessionConfiguration.shouldUseExtendedBackgroundIdleMode = true
        
        /// Not ideal, but in the private init, you cannot pass in a delegate to the initiliazer before all of self is initialized, hence the urlSession being initialized as a parameter
        /// Then initialized again here with a delegate.
        /// Here we create our base URLSession used for all video uploads in foreground and background.
        self.backgroundSession = URLSession(configuration: urlSessionConfiguration,
                                delegate: nil,
                                delegateQueue: nil)
    }
    
    private func getHeaders() -> Single<[String: String]> {
        guard let credentialsService = self.credentialsService else { return .just([:]) }
        
        if let accessToken = credentialsService.accessToken {
            return .just([
                "User-Agent": "\(Configuration.versionString)_\(Configuration.buildString)",
                "Authorization": "Bearer \(accessToken)"
            ])
        }

        return .error(BoomdayError.unsupported)
    }
    
    fileprivate func backgroundSessionRequest(withRequest request: URLRequest) -> Single<(HTTPURLResponse, Data)> {
        Logger.info(topic: .api, message: "backgroundSessionRequest called with request: \(request)")
        return Single<(HTTPURLResponse, Data)>.create { [self] single in
            DispatchQueue.global().async {
                let backgroundTask = UIApplication.shared.beginBackgroundTask()
                let dataTask = backgroundSession.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        single(.failure(error))
                    } else {
                        guard let response = response as? HTTPURLResponse,
                              let data = data else {
                            single(.failure(BoomdayError.internalMemoryError(text: "Failed loading response and data")))
                            return
                        }
                        
                        if !validStatusCodes.contains(response.statusCode) {
                            single(.failure(BoomdayError.apiStatusCode(code: response.statusCode)))
                        } else {
                            single(.success((response, data)))
                        }
                    }
                    
                    UIApplication.shared.endBackgroundTask(backgroundTask)
                }
                
                dataTask.resume()
            }
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    /// Background requests always send for a new refresh token
    fileprivate func refreshedBackgroundSessionRequest(request: URLRequest) -> Single<(HTTPURLResponse, Data)> {
        Logger.info(topic: .api, message: "refreshedBackgroundSessionRequest called")
        return backgroundRefreshCredentials()
            .flatMap { authenticateResponse -> Single<(HTTPURLResponse, Data)> in
                Logger.log(level: .info, topic: .api, message: "Background API Token Refresh complete")
                
                if let authenticateResponse = authenticateResponse {
                    self.credentialsService?.updateCredentials(accessToken: authenticateResponse.accessToken,
                                                               refreshToken: authenticateResponse.refreshToken)
                }
                    
                return self.backgroundSessionRequest(withRequest: request)
            }
    }
    
    /// Background requests always send for a new refresh token
    fileprivate func backgroundRequest(
        method: HTTPMethod,
        url: URL,
        parameters: Dictionary<String, String>? = nil) -> Single<(HTTPURLResponse, Data)> {
        
        guard let accessToken = credentialsService?.accessToken else { return .error(BoomdayError.refused) }
        
        var request = URLRequest(url: url)
        do {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(Configuration.versionString)_\(Configuration.buildString)", forHTTPHeaderField: "User-Agent")
            request.httpBody = try JSONEncoder().encode(parameters)
            request.httpMethod = method.rawValue
            
        } catch {
            return .error(BoomdayError.internalMemoryError(text: "Encoding parameters of standard values failed. Please contact support"))
        }
            
        return refreshedBackgroundSessionRequest(request: request)
    }
    
    private func queryStringBodyUnauthenticatedRequest(
        method: HTTPMethod,
        url: URL,
        parameters: APIParameters = [:],
        headers: Headers = [:],
        encoding: ParameterEncoding = URLEncoding.httpBody) -> Single<(HTTPURLResponse, Data)> {

        return session.rx
            .request(urlRequest: URLAPIQueryStringRequest(method,
                                                          url,
                                                          parameters: parameters,
                                                          headers: headers),
                     interceptor: self)
            .validate(statusCode: validStatusCodes)
            .responseData()
            .asSingle()
    }
    
    private func authenticatedRequest(
        method: HTTPMethod,
        url: URL,
        parameters: APIParameters = [:],
        encoding: ParameterEncoding = JSONEncoding.default,
        timeout: TimeInterval = 7.5) -> Single<(HTTPURLResponse, Data)> {
        
        Logger.info(topic: .api, message: "Sending request: \(url)")
        return getHeaders()
            .flatMap { [unowned self] headers -> Single<(HTTPURLResponse, Data)> in
                /// Setup request with session then use the URLRequestConvertible, otherwise no way to inject the timeout
                let request = session.request(url, method: method,
                                              parameters: parameters,
                                              encoding: encoding,
                                              headers: HTTPHeaders(headers)) {
                    $0.timeoutInterval = timeout
                }
                
                return self.session.rx
                    .request(urlRequest: request.convertible, interceptor: self)
                    .validate(statusCode: validStatusCodes)
                    .responseData()
                    .asSingle()
            }
    }
    
    //MARK: - Interceptor
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = credentialsService?.accessToken else {
            completion(.success(urlRequest))
            return
        }
        
        var modifiedUrlRequest = urlRequest
        modifiedUrlRequest.setValue("Bearer \(accessToken)",
                                    forHTTPHeaderField: "Authorization")
        completion(.success(modifiedUrlRequest))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void) {
        
        /// Check if we are getting an invalid authentication token response
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401,
              credentialsService?.refreshToken != nil else {
            completion(.doNotRetry)
            return
        }
        
        _ = refreshCredentials()
            .subscribe(onSuccess: { response in
                self.credentialsService?.updateCredentials(accessToken: response.accessToken,
                                                           refreshToken: response.refreshToken)
                
                completion(.retryWithDelay(1.0))
            }, onFailure: { error in
                Logger.log(level: .verbose,
                           topic: .api,
                           message: "Error retrieving accessToken when retrying failed request")
                completion(.doNotRetryWithError(error))
            })
    }
}


// MARK: - API Service

extension StandardAPIService : APIService {
    
    // MARK: Service Related
    func inject(credentialsService: CredentialsService) {
        self.credentialsService = credentialsService
    }
    
    // MARK: Video upload
    
    func createPost() -> Single<CreatePostResponse> {
        let url = baseUrl
                .appendingPathComponent("broadcaster")
                .appendingPathComponent("posts")
                
        return authenticatedRequest(method: .post, url: url)
                .decode(type: CreatePostResponse.self)
    }
    
    func getMediaUploadUrl(forPostID postID: PostID, for media: Media) -> Single<GetMediaUploadUrlResponse> {
        let url = baseUrl
            .appendingPathComponent("broadcaster")
            .appendingPathComponent("posts")
            .appendingPathComponent(postID)
            .appendingPathComponent("media")
        
        let parameters = ["contentType": media.contentType]
        
        return authenticatedRequest(method: .post, url: url, parameters: parameters)
            .decode(type: GetMediaUploadUrlResponse.self)
    }
    
    func getTrailerUploadUrl() -> Single<GetTrailerUploadUrlResponse> {
        let url = baseUrl
            .appendingPathComponent("broadcaster")
            .appendingPathComponent("trailer")
            .appendingPathComponent("media")
        
        let parameters = ["contentType": "video/mp4"]
        
        return authenticatedRequest(method: .post, url: url, parameters: parameters)
            .decode(type: GetTrailerUploadUrlResponse.self)
    }
    
    func uploadTrailerComplete() -> Completable {
        let url = baseUrl
            .appendingPathComponent("broadcaster")
            .appendingPathComponent("trailer")
            .appendingPathComponent("media")
            .appendingPathComponent("complete")
                
        return backgroundRequest(method: .post, url: url)
            .emptyResponseBody()
    }
    
    func uploadMedia(from fromUrl: URL, to toUrl: URL) -> Observable<(HTTPURLResponse?, RxProgress)> {
        let fileSize = fromUrl.fileSize()!
        let headers = HTTPHeaders(["x-ms-blob-type": "BlockBlob",
                                   "Content-Length": "\(fileSize)"])
        return self.session.rx
            .upload(fromUrl, to: toUrl, method: .put, headers: headers)
            .flatMap { (uploadRequest: UploadRequest) -> Observable<(HTTPURLResponse?, RxProgress)> in
                let progressPart = uploadRequest.rx.progress()
                
                /// The uploadRequest.rx.response() will only push an observable when there is a response, so the combineLatest never gets the progress update until a response is sent at the end, so we need change it to an optional by starting with a nil and concatenating the next one.
                let responsePart: Observable<HTTPURLResponse?> = Observable<HTTPURLResponse?>
                    .just(nil)
                    .concat(uploadRequest.rx.response().map { $0 })
                
                return Observable.combineLatest(responsePart, progressPart) { response, progress in
                    if let response = response,
                       !Array(200 ..< 300).contains(response.statusCode) {
                        throw BoomdayError.apiStatusCode(code: response.statusCode)
                    }
                    return (response, progress)
                }
            }
    }
    
    func uploadMediaComplete(for postId: PostID, _ mediaId: MediaID) -> Completable {
        let url = baseUrl
            .appendingPathComponent("broadcaster")
            .appendingPathComponent("posts")
            .appendingPathComponent(postId)
            .appendingPathComponent("media")
            .appendingPathComponent(mediaId)
            .appendingPathComponent("complete")
        
        return backgroundRequest(method: .post, url: url)//, timeout: 60)
            .emptyResponseBody()
    }
    
    func updatePostContent(postId: PostID, newContent: PostContent) -> Completable {
        let url = baseUrl
            .appendingPathComponent("broadcaster")
            .appendingPathComponent("posts")
            .appendingPathComponent(postId)
        
        let parameters = [
            "title": newContent.title,
            "caption": newContent.caption]
                
        return backgroundRequest(method: .put, url: url, parameters: parameters)
            .emptyResponseBody()
    }
    
    func publish(postId: PostID) -> Completable  {
        let url = baseUrl
            .appendingPathComponent("broadcaster")
            .appendingPathComponent("posts")
            .appendingPathComponent(postId)
            .appendingPathComponent("publish")
                
        return backgroundRequest(method: .post, url: url)
            .emptyResponseBody()
    }
    
    // MARK: Content Management
    
    func loadMyPosts() -> Single<LoadMyPostsResponse> {
        let url = baseUrl
            .appendingPathComponent("broadcaster")
            .appendingPathComponent("posts")
    
        return authenticatedRequest(method: .get, url: url, encoding: URLEncoding.default)
            .decode(type: LoadMyPostsResponse.self)
            
    }
    
    func loadProfile() -> Single<LoadProfileResponse> {
        let url = baseUrl
            .appendingPathComponent("broadcaster")
            .appendingPathComponent("profile")
        
        return authenticatedRequest(method: .get, url: url, encoding: URLEncoding.default)
            .decode(type: LoadProfileResponse.self)
    }
    
    func deletePost(with postId: PostID) -> Completable {
        let url = baseUrl
            .appendingPathComponent("broadcaster")
            .appendingPathComponent("posts")
            .appendingPathComponent(postId)
        
        return authenticatedRequest(method: .delete, url: url, encoding: URLEncoding.default)
            .emptyResponseBody()
    }
    
    // MARK: Update the user profile
    
    func updateProfile(withDisplayName displayName: String, biography: String) -> Completable {
        let url = baseUrl
            .appendingPathComponent("broadcaster")
            .appendingPathComponent("profile")
        
        let parameters = [
            "displayName": displayName,
            "biography": biography]
        
        return authenticatedRequest(method: .put, url: url, parameters: parameters)
            .emptyResponseBody()
    }
    
    func uploadProfileImage(withData data: Data) -> Observable<RxProgress> {
        let url = baseUrl
            .appendingPathComponent("broadcaster")
            .appendingPathComponent("profile")
            .appendingPathComponent("image")
        
        return getHeaders()
            .asObservable()
            .flatMap { [unowned self] headers -> Observable<RxProgress> in
                var extendedHeaders = headers
                extendedHeaders["Content-type"] = "multipart/form-data"
                
                return self.session.rx
                    .upload(multipartFormData: { multipartFormData in
                        multipartFormData.append(data, withName: "profileImage", fileName: "profileImage.jpeg", mimeType: "image/jpeg")
                    }, to: url, method: .put, headers: HTTPHeaders(extendedHeaders), interceptor: self)
                    .validate(statusCode: validStatusCodes)
                    .flatMap { (uploadRequest: UploadRequest) -> Observable<RxProgress> in
                        
                        let progressPart = uploadRequest.rx.progress()
                        let responsePart = uploadRequest.rx.response()
                        
                        return Observable.combineLatest(responsePart, progressPart) {
                            if !Array(200 ..< 300).contains($0.statusCode) {
                                throw BoomdayError.apiStatusCode(code: $0.statusCode)
                            }
                            return $1
                        }
                    }
            }
    }
}

extension StandardAPIService : AuthenticationService {
    func authenticate(withUsername username: String, password: String) -> Single<AuthenticateResponse> {
        let url = baseUrl
            .appendingPathComponent("connect")
            .appendingPathComponent("token")
        
        let parameters = ["username": username,
                          "password": password,
                          "grant_type": "password",
                          "scope": "offline_access"]
        
        let headers = ["X-Client-Id": "broadcaster-app"]
        
        return queryStringBodyUnauthenticatedRequest(method: .post,
                                                     url: url,
                                                     parameters: parameters,
                                                     headers: headers)
            .decode(type: AuthenticateResponse.self)
    }
    
    func backgroundRefreshCredentials() -> Single<AuthenticateResponse?> {
        guard let token = credentialsService?.refreshToken else { return .error(BoomdayError.refused) }
        Logger.info(topic: .debug, message: "backgroundRefreshCredentials called")
        
        let url = baseUrl
            .appendingPathComponent("connect")
            .appendingPathComponent("token")
        
        let parameters = ["refresh_token": token,
                          "grant_type": "refresh_token"]
        
        let requestConvertible = URLAPIQueryStringRequest(.post,
                                                          url,
                                                          parameters: parameters,
                                                          headers: [:])
        guard var request = try? requestConvertible.asURLRequest() else { return .error(BoomdayError.unknown) }
        request.timeoutInterval = TimeInterval(MAXFLOAT)
        
        return backgroundSessionRequest(withRequest: request)
            .decodeUnauthenticated(type: AuthenticateResponse.self)
    }
    
    func refreshCredentials() -> Single<AuthenticateResponse> {
        guard let token = credentialsService?.refreshToken else { return .error(BoomdayError.refused) }
        
        let url = baseUrl
            .appendingPathComponent("connect")
            .appendingPathComponent("token")
        
        let parameters = ["refresh_token": token,
                          "grant_type": "refresh_token"]
        
        return queryStringBodyUnauthenticatedRequest(method: .post, url: url, parameters: parameters)
            .decode(type: AuthenticateResponse.self)
    }
}

// MARK: - Instance

extension StandardAPIService {
    
    static let standard = {
        StandardAPIService()
    }()
    
    struct Dependencies {
        
        let baseUrl: URL
        let schedulers: Schedulers
        
        static let standard = Dependencies(
            baseUrl: Configuration.apiServiceURL,
            schedulers: Schedulers.standard)
    }
}
