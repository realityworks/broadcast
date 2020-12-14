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

class StandardAPIService {
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
    
    private func request(method: HTTPMethod,
                         url: URL,
                         parameters: APIParameters = [:],
                         encoding: ParameterEncoding = URLEncoding.httpBody) -> Single<(HTTPURLResponse, Data)> {

        return session.rx
            .request(urlRequest: URLAPIQueryStringRequest(method, url, parameters: parameters))
            .validate(statusCode: validStatusCodes)
            .responseData()
            .asSingle()
    }
    
    private func authenticatedRequest(method: HTTPMethod,
                                      url: URL,
                                      parameters: APIParameters = [:],
                                      encoding: ParameterEncoding = URLEncoding.httpBody) -> Single<(HTTPURLResponse, Data)> {
        return getHeaders()
            .flatMap { [unowned self] headers -> Single<(HTTPURLResponse, Data)> in
                return self.session.rx
                    .request(urlRequest: URLAPIQueryStringRequest(method, url, parameters: parameters))
                    .responseData()
                    .asSingle()
            }
    }
}

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
                    .upload(fromUrl, to: toUrl, method: .post, headers: HTTPHeaders(headers))
            }
    }
    
    func mediaComplete(postId: PostID, mediaId: MediaID) -> Completable {
        return Completable.empty()
    }
    
    func updatePostContent(postId: PostID, newContent: PostContent) -> Completable {
        return Completable.empty()
    }
    
    func publish(postId: PostID) -> Completable  {
        return Completable.empty()
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
        
        return request(method: .post, url: url, parameters: parameters)
            .decode(type: AuthenticateResponse.self)
    }
    
    func refresh(token: String) -> Single<AuthenticateResponse> {
        let single = Single<AuthenticateResponse>.create { observer in
            observer(.success(AuthenticateResponse(accessToken: "", refreshToken: "")))
            return Disposables.create { }
        }
        return single
    }
}

// MARK: - Instance

extension StandardAPIService {
    
    static let standard = {
        StandardAPIService()
    }()
    
    struct Dependencies {
        
        let credentialsService: CredentialsService
        let schedulers: Schedulers
        let baseUrl: URL
        
        static let standard = Dependencies(
            credentialsService: Services.standard.credentialsService,
            schedulers: Schedulers.standard,
            baseUrl: Configuration.apiServiceURL)
    }
}
