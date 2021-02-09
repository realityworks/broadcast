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
    private let persistenceService: PersistenceService
    
    let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies = .standard) {
        self.apiService = dependencies.apiService
        self.uploadService = dependencies.uploadService
        self.persistenceService = dependencies.persistenceService
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
        return ProfileUseCase()
    }()
}

// MARK: - Dependencies

extension ProfileUseCase {
    struct Dependencies {
        let apiService: APIService
        let uploadService: UploadService
        let persistenceService: PersistenceService
        
        static let standard = Dependencies(
            apiService: Services.standard.apiService,
            uploadService: Services.standard.uploadService,
            persistenceService: Services.standard.persistenceService)
    }
}

// MARK: - Functions

extension ProfileUseCase {
    func hasAcceptedTerms(forUser user: String) -> Bool {
        return persistenceService.read(key: user + PersistenceKeys.termsAccepted) == true
    }
    
    func acceptTerms(forUser user: String) {
        persistenceService.write(value: true,
                                 forKey: user + PersistenceKeys.termsAccepted)
    }
        
    private func loadProfileImage(fromUrl url: URL?) {
        guard let url = url else { return }
        SDWebImageManager.shared.loadImage(with: url, options: [.allowInvalidSSLCertificates, .continueInBackground], progress: nil) { (image, data, error, cacheType, finished, _) in
            /// Write the image to local data so we can refer to it when required
            guard let image = image else { return }
            self.updateLocalProfile(image: image)
        }
    }
    
    func loadProfile() {
        return apiService.loadProfile()
            .subscribe(onSuccess: { [self] profileResponse in
                stateController.state.profile = profileResponse
                loadProfileImage(fromUrl: URL(string: profileResponse.profileImageUrl))
            }, onFailure: { [self] error in
                stateController.sendError(error)
                Logger.log(level: .warning, topic: .authentication, message: "Unable to load account details with error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func reloadProfile() -> Single<LoadProfileResponse> {
        return apiService.loadProfile()
            .do(onSuccess: { [self] profileResponse in
                stateController.state.profile = profileResponse
                loadProfileImage(fromUrl: URL(string: profileResponse.profileImageUrl))
            }, onError: { [self] error in
                stateController.sendError(error)
                Logger.log(level: .warning, topic: .authentication, message: "Unable to load account details with error: \(error)")
            })
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
                self.stateController.state.currentTrailerUploadProgress?.failed = true
                if let boomDayError = error as? BoomdayError {
                    self.stateController.state.currentTrailerUploadProgress?.errorDescription = boomDayError.localizedDescription
                } else {
                    self.stateController.state.currentTrailerUploadProgress?.errorDescription = error.localizedDescription
                }
            }, onCompleted: {
                Logger.log(level: .info, topic: .api, message: "Trailer upload complete!")
                self.stateController.state.currentTrailerUploadProgress?.completed = true
                
                self.stateController.state.profile?.isTrailerProcessed = false
                self.stateController.state.profile?.trailerThumbnailUrl = nil
                self.stateController.state.profile?.trailerVideoUrl = nil
                
                self.loadProfile()
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
    
    func selectTrailerForUpload(withUrl url: URL) {
        stateController.state.selectedTrailerUrl = url
    }
    
    func clearTrailerForUpload() {
        stateController.state.selectedTrailerUrl = nil
        stateController.state.currentTrailerUploadProgress = UploadProgress()
    }
}
