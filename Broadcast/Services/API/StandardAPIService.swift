//
//  StandardAPIService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa

class StandardAPIService {
    private (set) var stateController: StateController
    
    init(stateController: StateController) {
        self.stateController = stateController
    }
}

extension StandardAPIService : APIService {
    func retrieveMyPosts() -> Single<LoadMyPostsResponse> {
        let single = Single<LoadMyPostsResponse>.create { observer in
            observer(.error(BoomdayError.unsupported))
            return Disposables.create { }
        }
        return single
    }
}

extension StandardAPIService : AuthenticationService {
    func authenticate(withUsername username: String, password: String) -> Single<AuthenticateResponse> {
        let single = Single<AuthenticateResponse>.create { observer in
            observer(.error(BoomdayError.unsupported))
            return Disposables.create { }
        }
        return single
    }
}

// MARK: - Instance

extension StandardAPIService {
    static let standard = {
        StandardAPIService(stateController: Domain.standard.stateController)
    }()
}
