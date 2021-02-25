//
//  ProfileDetailViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SwiftRichString

class ProfileDetailViewModel : ViewModel {
    
    enum Row {
        case profileInfo(profileImage: UIImage, displayName: String, subscribers: Int)
        case displayName(text: String)
        case biography(text: String)
        case email(text: String)
        case handle(text: String)
        case trailerVideo
        case simpleInfo(text: LocalizedString)
        case spacer(height: CGFloat)
    }
        
    let schedulers: Schedulers
    let profileUseCase: ProfileUseCase
    
    let isActive = BehaviorRelay<Bool>(value: true)
    let reloadProfileSignal = PublishRelay<()>()

    let subscriberCount: Observable<Int>
    let profileImage: Observable<UIImage>

    let displayNameObservable: Observable<String?>
    let displayNameSubject = BehaviorRelay<String?>(value: nil)
    let biographyObservable: Observable<String?>
    let biographySubject = BehaviorRelay<String?>(value: nil)
    let emailObservable: Observable<String?>
    let emailSubject = BehaviorRelay<String?>(value: nil)
    let handleObservable: Observable<String?>
    let handleSubject = BehaviorRelay<String?>(value: nil)

    // Uploading new profile image management
    private let isUploadingProfileImageSubject = BehaviorSubject<Bool>(value: false)
    let isUploadingProfileImage: Observable<Bool>

    // Uploading new trailer management
    private let isUploadingTrailerSubject = BehaviorSubject<Bool>(value: false)
    let isUploadingTrailer: Observable<Bool>
    let progress: Observable<Float>
    let progressText: Observable<String>
    
    let showTrailerProcessing: Observable<Bool>
    
    let selectedTrailerUrl: Observable<URL?>
    let trailerVideoUrl: Observable<URL?>
    let trailerThumbnailUrl: Observable<URL?>
    let runTimeTitle: Observable<NSAttributedString>
    let mediaTypeTitle: Observable<String>
    let showingTrailer: Observable<Bool>

    let uploadComplete: Observable<Bool>
    let showFailed = BehaviorRelay<Bool>(value: false)
    let showProgressView: Observable<Bool>
    let showUploadButton: Observable<Bool>
    let selectedNewTrailerRelay = PublishRelay<Bool>()

    private let savingProfileRelay = BehaviorRelay<Bool>(value: false)
    private let finishedSavingProfileRelay = PublishRelay<()>()
    let finishedSavingProfileSignal: Observable<()>
    let savingProfile: Observable<Bool>
    

    private let finishedReloadProfileSignal = PublishRelay<()>()
    let finishedReloadProfile: Observable<()>

    private let resignRespondersSignal = PublishRelay<()>()
    let resignResponders: Observable<()>

    
    init(dependencies: Dependencies = .standard) {
        
        self.schedulers = dependencies.schedulers
        self.profileUseCase = dependencies.profileUseCase
        
        let uploadingProgressObservable = dependencies.trailerUploadProgress.compactMap { $0 }
        let profileObservable = dependencies.profileObservable.compactMap { $0 }
        
        displayNameObservable = profileObservable.map { $0.displayName }
        biographyObservable = profileObservable.map { $0.biography ?? String.empty }
        emailObservable = profileObservable.map { $0.email ?? String.empty }
        handleObservable = profileObservable.map { $0.handle }

        subscriberCount = profileObservable.map { $0.subscriberCount }
        profileImage = dependencies.profileImage.compactMap { $0 ?? dependencies.profileUseCase.localProfileImage() }

        selectedTrailerUrl = dependencies.selectedTrailerUrlObservable
        trailerThumbnailUrl = profileObservable.map { URL(string: $0.trailerThumbnailUrl)?.appendingQueryItem("utc", value: "\(Int64(Date.now.timeIntervalSince1970*1000))") }

        trailerVideoUrl = Observable.combineLatest(
            profileObservable.map { URL(string: $0.trailerVideoUrl) },
            selectedTrailerUrl) { profileTrailerUrl, selectedTrailerUrl in
            return selectedTrailerUrl ?? profileTrailerUrl
        }

        runTimeTitle = self.trailerVideoUrl
            .compactMap { $0 }
            .map { url in
                let media = Media.video(url: url)
                return LocalizedString.duration.localized.set(style: Style.smallBody).set(style: Style.lightGrey) +
                    (" " + media.duration).set(style: Style.smallBody)
            }

        mediaTypeTitle = self.trailerVideoUrl.map { url in
            switch url {
            case nil:
                return LocalizedString.none.localized
            default:
                return LocalizedString.video.localized
            }
        }

        isUploadingProfileImage = isUploadingProfileImageSubject.asObservable()
        isUploadingTrailer = isUploadingTrailerSubject.asObservable()

        progress = uploadingProgressObservable.map { $0.totalProgress }

        /// We don't want the compact map version, handle different case upload progress
        progressText = dependencies.trailerUploadProgress.map { uploadProgress in
            guard let uploadProgress = uploadProgress else {
                return UploadProgress.initialProgressText
            }

            return uploadProgress.progressText
        }

        uploadComplete = dependencies.trailerUploadProgress
            .map { $0?.completed ?? false }

        let isProgressViewActive: Observable<Bool> = Observable.combineLatest(
            uploadComplete,
            isUploadingTrailer) { uploadComplete, isUploadingTrailer in
                return (uploadComplete || isUploadingTrailer)
            }

        let hasSelectedNewTrailerAfterUpload = selectedNewTrailerRelay
            .withLatestFrom(uploadComplete)
            .filter { $0 == true }
            .map { _ in () }

        showProgressView = Observable.merge(
            isProgressViewActive,
            hasSelectedNewTrailerAfterUpload.map { _ in false })

        showUploadButton = showProgressView.map { !$0 }
        
        let hasTrailer = profileObservable
            .map { $0.hasTrailer }
        
        let isTrailerVideoProcessed = profileObservable
            .map { $0.isTrailerProcessed }
        
        showTrailerProcessing = Observable.combineLatest(hasTrailer, isTrailerVideoProcessed, selectedTrailerUrl) { hasTrailer, processed, selectedTrailerUrl in
            return (hasTrailer && !processed) && selectedTrailerUrl == nil
        }

        savingProfile = savingProfileRelay.asObservable()

        finishedReloadProfile = finishedReloadProfileSignal.asObservable()
        
        resignResponders = resignRespondersSignal.asObservable()
        
        showingTrailer = Observable.combineLatest(
            trailerVideoUrl,
            hasTrailer,
            selectedTrailerUrl) { trailerUrl, hasTrailer, selectedTrailerUrl in
            return (trailerUrl != nil && hasTrailer == true) || selectedTrailerUrl != nil
        }
        
        finishedSavingProfileSignal = finishedSavingProfileRelay.asObservable()
        
        super.init(stateController: dependencies.stateController)
        
        displayNameObservable
            .subscribe(onNext: { [weak self] value in self?.displayNameSubject.accept(value) })
            .disposed(by: disposeBag)

        biographyObservable
            .subscribe(onNext: { [weak self] value in self?.biographySubject.accept(value) })
            .disposed(by: disposeBag)

        emailObservable
            .subscribe(onNext: { [weak self] value in self?.emailSubject.accept(value) })
            .disposed(by: disposeBag)

        handleObservable
            .subscribe(onNext: { [weak self] value in self?.handleSubject.accept(value) })
            .disposed(by: disposeBag)

        uploadingProgressObservable
            .map { !($0.completed || $0.failed) }
            .distinctUntilChanged()
            .bind(to: self.isUploadingTrailerSubject)
            .disposed(by: disposeBag)

        selectedTrailerUrl.compactMap { _ in true }
            .bind(to: selectedNewTrailerRelay)
            .disposed(by: disposeBag)

        dependencies.trailerUploadProgress
            .map { $0?.failed == true }
            .distinctUntilChanged()
            .bind(to: showFailed)
            .disposed(by: disposeBag)
        
        // If app is in background, wait until it is in foreground, otherwise proceed
        reloadProfileSignal
            .subscribe(onNext: { _ in
                self.loadProfile(resetSelectedTrailerAfterLoad: true)
            })
            .disposed(by: disposeBag)

        dependencies.didBecomeActive
            .subscribe { [weak self] _ in
                self?.isActive.accept(true)
            }
            .disposed(by: disposeBag)

        dependencies.willResignActive
            .subscribe { [weak self] _ in
                self?.isActive.accept(false)
            }
            .disposed(by: disposeBag)
        
        configureActiveUploadBindings()
    }
    
    private func configureActiveUploadBindings() {
        Observable.combineLatest(uploadComplete.distinctUntilChanged(), isActive.asObservable())
            .map { uploadComplete, isActive in
                return uploadComplete == true && isActive == true
            }
            .filter { $0 == true }
            .map { _ in () }
            .bind(to: reloadProfileSignal)
            .disposed(by: disposeBag)
    }
}

/// NewPostViewModel dependencies component
extension ProfileDetailViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let schedulers: Schedulers
        let profileUseCase: ProfileUseCase
        let profileImage: Observable<UIImage?>
        let profileObservable: Observable<Profile?>
        let trailerUploadProgress: Observable<UploadProgress?>
        let selectedTrailerUrlObservable: Observable<URL?>
        let didBecomeActive: Observable<Void>
        let willResignActive: Observable<Void>
        
        static var standard: Dependencies {
            let notificationCenter = NotificationCenter.default.rx
            return Dependencies(
                stateController: Domain.standard.stateController,
                schedulers: Schedulers.standard,
                profileUseCase: Domain.standard.useCases.profileUseCase,
                profileImage: Domain.standard.stateController.stateObservable(of: \.profileImage),
                profileObservable: Domain.standard.stateController.stateObservable(of: \.profile),
                trailerUploadProgress: Domain.standard.stateController.stateObservable(of: \.currentTrailerUploadProgress),
                selectedTrailerUrlObservable: Domain.standard.stateController.stateObservable(of: \.selectedTrailerUrl),
                didBecomeActive: notificationCenter.notification(UIApplication.didBecomeActiveNotification).map { _ in () },
                willResignActive: notificationCenter.notification(UIApplication.willResignActiveNotification).map { _ in () })
        }
    }
}

// MARK: - ViewModel functions

extension ProfileDetailViewModel {
    func prepareData() {
        profileUseCase.clearTrailerForUpload()
    }

    func updateProfile() {
        guard let displayName = displayNameSubject.value,
              let biography = biographySubject.value else { return }
        Logger.log(level: .info, topic: .debug, message: "Saving:\nDisplayName: \(displayName)\nBiography: \(biography)")

        saveProfileStart()
        profileUseCase.updateProfile(displayName: displayName,
                                     biography: biography)
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                Logger.log(level: .info, topic: .debug, message: "Updated profile sucessfully!")

                // Mark as update complete (loader)
                self.profileUseCase.updateLocalProfile(displayName: displayName,
                                                        biography: biography)
                self.saveProfileFinish()
            }, onError: { [weak self] error in
                Logger.log(level: .warning, topic: .debug, message: "Unable to update the broadcaster profile: \(error)")

                guard let self = self else { return }

                // Revert display name and biography if save failed
                self.profileUseCase.updateLocalProfile(
                    displayName: self.stateController.state.profile?.displayName ?? "",
                    biography: self.stateController.state.profile?.biography ?? "")

                self.stateController.sendError(error)
                self.saveProfileFinish()
                
            })
            .disposed(by: disposeBag)
    }

    func profileImageSelected(withUrl url: URL) {
        isUploadingProfileImageSubject.onNext(true)

        profileUseCase.updateProfile(image: url)
            .subscribe(onNext: { progress in
                Logger.log(level: .info, topic: .debug, message: "Uploading profile image progress: \(progress)")
            }, onError: { [weak self] error in
                /// Revert to original image
                guard let self = self else { return }

                self.isUploadingProfileImageSubject.onNext(false)
                Logger.log(level: .info, topic: .debug, message: "Failed uploading profile image!")
                self.stateController.sendError(error)
            }, onCompleted: { [weak self] in
                guard let self = self else { return }
                Logger.log(level: .info, topic: .debug, message: "Uploading profile image complete!")
                self.isUploadingProfileImageSubject.onNext(false)
            })
            .disposed(by: disposeBag)
    }

    func trailerSelected(withUrl url: URL) {
        profileUseCase.selectTrailerForUpload(withUrl: url)
    }

    func uploadTrailer(withUrl url: URL) {
        isUploadingTrailerSubject.onNext(true)
        profileUseCase.uploadTrailer(withUrl: url)
    }
    
    func loadProfile(resetSelectedTrailerAfterLoad: Bool = false) {
        profileUseCase.loadProfile() { [weak self] success in
            if resetSelectedTrailerAfterLoad && success{
                self?.profileUseCase.removeSelectedTrailer()
            }
        }
    }
    
    func willResignResponders() {
        resignRespondersSignal.accept(())
    }
    
    private func saveProfileStart() {
        savingProfileRelay.accept(true)
    }
    
    private func saveProfileFinish() {
        self.finishedSavingProfileRelay.accept(())
        
        /// This needs to in sync with the SavingView animation timing also (Not ideal, but how to
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.savingProfileRelay.accept(false)
        }
    }
}
