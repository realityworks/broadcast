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
    
    func create(newPost: NewPost) -> Completable {
        return Completable.empty()
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
