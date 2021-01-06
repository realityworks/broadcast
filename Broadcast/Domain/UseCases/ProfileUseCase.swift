//
//  ProfileUseCase.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

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
            apiService: Services.standard.apiService,
            uploadService: Services.standard.uploadService)
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
                Logger.log(level: .warning, topic: .authentication, message: "Unable to load account details with error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func updateProfile(displayName: String, biography: String) -> Completable {
        return apiService.updateProfile(withDisplayName: displayName, biography: biography)
    }
    
    func uploadTrailer(withUrl url: URL) {
        #warning("TODO")
        //uploadService.upload(media: .video(fileUrl: url))
    }
    
    func uploadProfileImage(withUrl url: URL) -> Observable<RxProgress> {
        do {
            let data = try Data(contentsOf: url)
            return apiService.uploadProfileImage(withData: data)
        } catch {
            stateController.sendError(error)
            Logger.log(level: .warning, topic: .authentication, message: "Cannot get image data: \(error)")
            return .error(error)
        }
    }
}
