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
        stateController.state.currentTrailerUploadProgress = UploadProgress()
        uploadService.uploadTrailer(from: url)
            .subscribe(onNext: { uploadProgress in
                Logger.log(level: .info, topic: .api, message: "Upload progress : \(uploadProgress.progress)")
                self.stateController.state.currentTrailerUploadProgress = uploadProgress
            }, onError: { error in
                print(error)
                self.stateController.state.currentTrailerUploadProgress?.failed = true
                if let boomDayError = error as? BoomdayError {
                    self.stateController.state.currentTrailerUploadProgress?.errorDescription = boomDayError.localizedDescription
                } else {
                    self.stateController.state.currentTrailerUploadProgress?.errorDescription = error.localizedDescription
                }
            }, onCompleted: {
                Logger.log(level: .info, topic: .api, message: "Trailer upload complete!")
                self.stateController.state.currentTrailerUploadProgress?.completed = true
            })
            .disposed(by: disposeBag)
        
    }
    
    func updateLocalProfile(displayName: String, biography: String) {
        stateController.state.profile?.displayName = displayName
        stateController.state.profile?.biography = biography
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
}
