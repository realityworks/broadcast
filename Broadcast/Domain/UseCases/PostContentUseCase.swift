//
//  PostContentUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa

class PostContentUseCase {
    typealias T = PostContentUseCase
    
    var disposeBag = DisposeBag()
    
    var stateController: StateController!
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func retrieveMyPosts() {
        // Load posts into the app state
        apiService.retrieveMyPosts()
            .subscribe(onSuccess: { [unowned self] response in
                self.stateController.state.myPosts = response.posts
            }, onError: { [unowned self] error in
                #warning("TODO")
                Logger.log(level: .error, topic: .api, message: "Failed to load posts \(error)")
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - StateControllerInjector

extension PostContentUseCase : StateControllerInjector {
    @discardableResult
    func with(stateController: StateController) -> PostContentUseCase {
        self.stateController = stateController
        return self
    }
}

// MARK: - Instances

extension PostContentUseCase {
    static let standard = {
        return PostContentUseCase(apiService: Services.local.apiService)
    }()
}
