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
    
    static let queue = DispatchQueue(label: "thread-safe-profile-use-case", attributes: .concurrent)
    
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
        
    func loadProfileImage(fromUrl url: URL?) {
        guard let url = url else { return }
        SDWebImageManager.shared.loadImage(with: url, options: [.allowInvalidSSLCertificates, .continueInBackground, .scaleDownLargeImages], progress: nil) { [self] (image, data, error, cacheType, finished, _) in
            
            /// Write the image to local data so we can refer to it when required
            guard let image = image,
                  let data = image.orientationRemoved().pngData()
                else { return }
            let imageUrl = FileManager.default.documentsDirectory().appendingPathComponent("profile.png")
            try? data.write(to: imageUrl)
            self.updateLocalProfile(image: imageUrl)
        }
    }
    
    func loadProfile(completionHandler: ((Bool)->Void)? = nil) {
        return apiService.loadProfile()
            .subscribe(onSuccess: { [self] profileResponse in
                stateController.state.profile = profileResponse
                removeLocalProfileImage()
                loadProfileImage(fromUrl: URL(string: profileResponse.profileImageUrl)?.appendingQueryItem("w", value: "600"))
                completionHandler?(true)
            }, onFailure: { [self] error in
                stateController.sendError(error)
                Logger.log(level: .warning, topic: .authentication, message: "Unable to load account details with error: \(error)")
                completionHandler?(false)
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
    
    func localProfileImage() -> UIImage? {
        guard let data: Data = persistenceService.read(key: PersistenceKeys.profileImage) else {
            return UIImage.defaultProfileImage
        }
        
        return UIImage(data: data)
    }
    
    func updateLocalProfile(displayName: String, biography: String) {
        stateController.state.profile?.displayName = displayName
        stateController.state.profile?.biography = biography
    }
    
    func removeLocalProfileImage() {
        persistenceService.remove(key: PersistenceKeys.profileImage)
    }
    
    func updateLocalProfile(image url: URL) {
        Logger.log(level: .info, topic: .debug, message: "Updating Local Profile with image at: \(url)")
        if let image = UIImage(contentsOfFile: url.path) {
            Logger.log(level: .info, topic: .debug, message: "Image exists, updating local data!")
            persistenceService.write(value: image.pngData(), forKey: PersistenceKeys.profileImage)
            stateController.state.profileImage = image
            stateController.state.profile?.profileImageUrl = url.absoluteString
        }
    }
    
    func updateProfile(image url: URL) -> Observable<RxProgress> {
        do {
            /// Local state management uses a local file url to revert to so if the image upload fails we can revert to a local version of the file
            let originalProfileImage = stateController.state.profileImage
            let originalProfileUrl = stateController.state.profile?.profileImageUrl
            
            let data = try Data(contentsOf: url)
            
            updateLocalProfile(image: url)
            return apiService.uploadProfileImage(withData: data)
                .do(onError: { [unowned self] error in
                    self.persistenceService.write(value: originalProfileImage?.pngData(),
                                                  forKey: PersistenceKeys.profileImage)
                    
                    self.stateController.state.profileImage = originalProfileImage
                    self.stateController.state.profile?.profileImageUrl = originalProfileUrl
                })
        } catch {
            Logger.log(level: .warning, topic: .authentication, message: "Cannot get image data: \(error)")
            return .error(error)
        }
    }
    
    func removeSelectedTrailer() {
        stateController.state.selectedTrailerUrl = nil
    }
    
    func selectTrailerForUpload(withUrl url: URL) {
        stateController.state.selectedTrailerUrl = url
    }
    
    func clearTrailerForUpload() {
        stateController.state.selectedTrailerUrl = nil
        stateController.state.currentTrailerUploadProgress = nil
    }
}
