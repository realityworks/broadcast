//
//  LocalAuthenticationService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa

/// The service performs only local authentication and login/logout
class LocalAuthenticationService : AuthenticationService {
    private (set) var stateController: StateController
    
    init(stateController: StateController) {
        self.stateController = stateController
    }
    
    func authenticate(withUsername username: String, password: String) -> Single<AuthenticateResponse> {
        
        let single = Single<AuthenticateResponse>.create { observer in
            observer(.success(AuthenticateResponse(authenticationToken: "", refreshToken: "")))
            return Disposables.create { }
        }
        return single
    }
}

// MARK: - Instance

extension LocalAuthenticationService {
    static let standard = {
        LocalAuthenticationService(stateController: Domain.standard.stateController)
    }()
}
