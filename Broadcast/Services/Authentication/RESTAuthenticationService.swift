//
//  RESTAuthenticationService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 9/12/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

/// The service performs only local authentication and login/logout
class RESTAuthenticationService : AuthenticationService {
    let baseUrl: URL
    let session: Session
    
    init(dependencies: Dependencies = .standard) {
        self.baseUrl = dependencies.baseUrl
        self.session = Session.default
    }
    
    private func request(method: HTTPMethod,
                         url: URLConvertible,
                         body: String?,
                         encoding: ParameterEncoding = URLEncoding.httpBody) -> Single<(HTTPURLResponse, Data)> {

        
        
        return session.rx.request(URL())
            .responseData()
            .asSingle()
    }
    
    func authenticate(withUsername username: String, password: String) -> Single<AuthenticateResponse> {
        let url = baseUrl
            .appendingPathComponent("connect")
            .appendingPathComponent("account")
        
        let payload = ["username": username,
                       "password": password,
                       "grant_type": "password",
                       "scope": "offline_access",]
        
        return request(method: .post, url: url, body: payload.queryString)
            .decode(type: AuthenticateResponse.self)
    }
    
    func refresh(token: String) -> Single<AuthenticateResponse> {
        let single = Single<AuthenticateResponse>.create { observer in
            observer(.success(AuthenticateResponse(authenticationToken: "", refreshToken: "")))
            return Disposables.create { }
        }
        return single
    }
}

// MARK: - Instance

extension RESTAuthenticationService {
    struct Dependencies {
        
        let baseUrl: URL
        
        static let standard = Dependencies(baseUrl: Configuration.apiServiceURL)
    }
}

// MARK: - Dependencies
