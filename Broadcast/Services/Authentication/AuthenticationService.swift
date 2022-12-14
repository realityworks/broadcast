//
//  AuthenticationServiceProtocol.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa

protocol AuthenticationService {
    func authenticate(withUsername username: String, password: String) -> Single<AuthenticateResponse>
    func refreshCredentials() -> Single<AuthenticateResponse>
    func backgroundRefreshCredentials() -> Single<AuthenticateResponse?>
}

