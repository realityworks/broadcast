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
    func refresh(token: String) -> Single<AuthenticateResponse>
}

