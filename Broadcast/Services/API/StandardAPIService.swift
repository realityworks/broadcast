//
//  StandardAPIService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

typealias APIParameters = Dictionary<String, String>

class StandardAPIService : Interceptor {
    let baseUrl: URL
    let session: Session
    let schedulers: Schedulers
    
    var credentialsService: CredentialsService?
    
    private let validStatusCodes = [Int](200 ..< 300) + [400, 404, 409, 503, 504]
    
    init(dependencies: Dependencies = .standard) {
        self.baseUrl = dependencies.baseUrl
        self.schedulers = dependencies.schedulers
        self.session = Session.default
        self.credentialsService = nil
        super.init()
    }
    
    #warning("Todo in handling refresh token")
//    func getAccessToken() -> Single<String> {
//        let url = baseURL
//            .appendingPathComponent("oauth")
//            .appendingPathComponent("token")
//
//        guard let pairingToken = credentialsService.pairingToken else { return .error(APIError.notAuthenticated) }
//
//        let payload = [
//            "grant_type": "refresh_token",
//            "refresh_token": pairingToken,
//            "client_id": "app",
//        ]
//
//        return request(method: .post, url: url, parameters: payload)
//            .decode(type: AuthenticateResponse.self)
//            .map { $0.accessToken }
//            .do(onSuccess: { accessToken in
//                self.credentialsService.accessToken = accessToken
//            })
//    }
    
    private func getHeaders() -> Single<[String: String]> {
        guard let credentialsService = self.credentialsService else { return .just([:]) }
        
        if let accessToken = credentialsService.accessToken {
            return .just([
                "Authorization": "Bearer \(accessToken)",
            ])
        }

        return .error(BoomdayError.unsupported)
    }
    
    private func queryStringBodyUnauthenticatedRequest(
        method: HTTPMethod,
        url: URL,
        parameters: APIParameters = [:],
        encoding: ParameterEncoding = URLEncoding.httpBody) -> Single<(HTTPURLResponse, Data)> {

        return session.rx
            .request(urlRequest: URLAPIQueryStringRequest(method, url, parameters: parameters),
                     interceptor: self)
            .validate(statusCode: validStatusCodes)
            .responseData()
            .asSingle()
    }
    
    private func authenticatedRequest(
        method: HTTPMethod,
        url: URL,
        parameters: APIParameters = [:],
        encoding: ParameterEncoding = JSONEncoding.default) -> Single<(HTTPURLResponse, Data)> {
        
        return getHeaders()
            .flatMap { [unowned self] headers -> Single<(HTTPURLResponse, Data)> in
                return self.session.rx
                    .request(method, url,
                             parameters: parameters,
                             encoding: encoding,
                             headers: HTTPHeaders(headers),
                             interceptor: self)
                    .responseData()
                    .asSingle()
            }
    }
    
    //MARK: - Interceptor
    override func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        
        /// Check if we are getting an invalid authentication token response
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401,
              let refreshToken = credentialsService?.refreshToken else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        _ = refresh(token: refreshToken)
            .subscribe(onSuccess: { response in
                self.credentialsService?.updateCredentials(accessToken: response.accessToken,
                                                           refreshToken: response.refreshToken)
                
                completion(.retryWithDelay(1.0))
            }, onError: { error in
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
    
    func getUploadUrl(forPostID postID: PostID) -> Single<GetUploadUrlResponse> {
        let url = baseUrl
            .appendingPathComponent("posts")
            .appendingPathComponent(postID)
            .appendingPathComponent("media")
                
        return authenticatedRequest(method: .post, url: url)
            .decode(type: GetUploadUrlResponse.self)
    }
    
    func uploadVideo(from fromUrl: URL, to toUrl: URL) -> Observable<RxProgress> {
        return getHeaders()
            .asObservable()
            .flatMap { [unowned self] headers -> Observable<RxProgress> in
                return self.session.rx
                    .upload(fromUrl, to: toUrl, method: .put, headers: HTTPHeaders(headers))
            }
    }
    
    func mediaComplete(postId: PostID, mediaId: MediaID) -> Completable {
        let url = baseUrl
            .appendingPathComponent("posts")
            .appendingPathComponent(postId)
            .appendingPathComponent("media")
            .appendingPathComponent(mediaId)
                
        return authenticatedRequest(method: .post, url: url)
            .emptyResponseBody()
    }
    
    func updatePostContent(postId: PostID, newContent: PostContent) -> Completable {
        let url = baseUrl
            .appendingPathComponent("posts")
            .appendingPathComponent(postId)
        
        let parameters = [
            "title": newContent.title,
            "caption": newContent.caption]
        
        return authenticatedRequest(method: .put, url: url, parameters: parameters)
            .emptyResponseBody()
    }
    
    func publish(postId: PostID) -> Completable  {
        let url = baseUrl
            .appendingPathComponent("posts")
            .appendingPathComponent(postId)
            .appendingPathComponent("publish")
                
        return authenticatedRequest(method: .post, url: url)
            .emptyResponseBody()
    }
    
    // MARK: Content loading
    
    func loadMyPosts() -> Single<LoadMyPostsResponse> {
        let single = Single<LoadMyPostsResponse>.create { observer in
            observer(.error(BoomdayError.unsupported))
            return Disposables.create { }
        }
        return single
    }
    
    func loadProfile() -> Single<LoadProfileResponse> {
        let single = Single<LoadProfileResponse>.create { observer in
            observer(.error(BoomdayError.unsupported))
            return Disposables.create { }
        }
        return single
    }
    
    func updateProfile(withDisplayName displayName: String, biography: String) -> Completable {
        return Completable.empty()
    }
    
    func uploadProfileImage(withData: Data) -> Completable {
        return Completable.empty()
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
        
        return queryStringBodyUnauthenticatedRequest(method: .post, url: url, parameters: parameters)
            .decode(type: AuthenticateResponse.self)
    }
    
    func refresh(token: String) -> Single<AuthenticateResponse> {
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
