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

typealias RESTParameters

/// The service performs only local authentication and login/logout
class RESTAuthenticationService : AuthenticationService {
    

    
}

// MARK: - Instance

extension RESTAuthenticationService {
    struct Dependencies {
        
        let baseUrl: URL
        
        static let standard = Dependencies(baseUrl: Configuration.apiServiceURL)
    }
}

// MARK: - Dependencies
