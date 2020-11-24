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
    var stateController: StateController { get }
    
    func authenticate(withUsername username: String, password: String) -> Single<AuthenticateResponse>
}

