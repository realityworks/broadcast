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
import SDWebImage

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
    private func loadProfileImage(fromUrl url: URL?) {
        guard let url = url else { return }
        SDWebImageManager.shared.loadImage(with: url, options: [.allowInvalidSSLCertificates, .continueInBackground], progress: nil) { (image, data, error, cacheType, finished, _) in
            /// Write the image to local data so we can refer to it when required
            guard let image = image else { return }
            self.updateLocalProfile(image: image)
        }
    }
    
    func loadProfile() {
        apiService.loadProfile()
            .subscribe(onSuccess: { [self] profileResponse in
                stateController.state.profile = profileResponse
                loadProfileImage(fromUrl: URL(string: profileResponse.profileImageUrl))
            }, onFailure: { [self] error in
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
    
    func updateLocalProfile(image: UIImage) {
        image.write(toKey: UIImage.profileImageKey)
        stateController.state.profileImage = image
    }
    
    func updateProfile(image url: URL) -> Observable<RxProgress> {
        do {
            let data = try Data(contentsOf: url)
            return apiService.uploadProfileImage(withData: data)
        } catch {
            Logger.log(level: .warning, topic: .authentication, message: "Cannot get image data: \(error)")
            return .error(error)
        }
    }
    
    func updateProfileTrailer(from url: URL) {
        uploadService.uploadTrailer(from: url)
            .subscribe(onNext: { uploadProgress in
                Logger.log(level: .info, topic: .api, message: "Upload progress : \(uploadProgress.progress)")
                self.stateController.state.currentUploadProgress = uploadProgress
            }, onError: { error in
                self.stateController.state.currentUploadProgress?.failed = true
                if let boomDayError = error as? BoomdayError {
                    self.stateController.state.currentUploadProgress?.errorDescription = boomDayError.localizedDescription
                } else {
                    self.stateController.state.currentUploadProgress?.errorDescription = error.localizedDescription
                }
            }, onCompleted: {
                Logger.log(level: .info, topic: .api, message: "Post content complete!")
                self.stateController.state.currentUploadProgress?.completed = true
            })
            .disposed(by: disposeBag)
    }
    
}
