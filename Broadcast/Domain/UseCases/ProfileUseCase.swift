//
//  ProfileUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift

class ProfileUseCase {
    typealias T = ProfileUseCase
    
    var stateController: StateController!
    
    private let apiService: APIService
    private let uploadService: UploadService
    
    let disposeBag = DisposeBag()
    
    init(apiService: APIService,
         uploadService: UploadService) {
        self.apiService = apiService
        self.uploadService = uploadService
    }
}

// MARK: - StateControllerInjector

extension ProfileUseCase : StateControllerInjector {
    @discardableResult
    func with(stateController: StateController) -> ProfileUseCase {
        self.stateController = stateController
        return self
    }
}

// MARK: - Instances

extension ProfileUseCase {
    static let standard = {
        return ProfileUseCase(
            apiService: Services.local.apiService,
            uploadService: Services.local.uploadService)
    }()
}

// MARK: - Functions

extension ProfileUseCase {
    func loadProfile() {
        apiService.loadProfile()
            .subscribe(onSuccess: { [self] profileResponse in
                stateController.state.profile = profileResponse
            }, onError: { [self] error in
                stateController.sendError(error)
                Logger.log(level: .warning, topic: .authentication, message: "Unable to load account details")
            })
            .disposed(by: disposeBag)
    }
    
    func updateProfile(displayName: String, biography: String) {
        
    }
    
    func uploadTrailer(withUrl url: URL) {
        #warning("TODO")
        //uploadService.upload(media: .video(fileUrl: url))
    }
}
