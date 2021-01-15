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
    }
        
    let schedulers: Schedulers
    let profileUseCase: ProfileUseCase

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
    
    // Uploading new trailer management
    private let isUploadingSubject = BehaviorSubject<Bool>(value: false)
    let isUploading: Observable<Bool>
    let progress: Observable<Float>
    let progressText: Observable<String>
    
    let selectedTrailerRelay = PublishRelay<URL?>()
    let trailerVideoUrl: Observable<URL?>
    let runTimeTitle: Observable<NSAttributedString>
    let mediaTypeTitle: Observable<String>
    let showingTrailer: Observable<Bool>
    let uploadComplete: Observable<Bool>
    
    let showProgressView: Observable<Bool>
    let showUploadButton: Observable<Bool>
    let selectedNewTrailerRelay = PublishRelay<Bool>()
    
    init(dependencies: Dependencies = .standard) {
        
        self.schedulers = dependencies.schedulers
        self.profileUseCase = dependencies.profileUseCase
        
        let uploadingProgressObservable = dependencies.trailerUploadProgress.compactMap { $0 }
        let profileObservable = dependencies.profileObservable.compactMap { $0 }
        
        displayNameObservable = profileObservable.map { $0.displayName }
        biographyObservable = profileObservable.map { $0.biography ?? String.empty }
        emailObservable = profileObservable.map { _ in "---" }
        handleObservable = profileObservable.map { $0.handle }
        
        subscriberCount = profileObservable.map { $0.subscriberCount }
        profileImage = dependencies.profileImage.compactMap { $0 ?? UIImage.profileImage }
        
        trailerVideoUrl = Observable.merge(
            profileObservable.map { URL(string: $0.trailerVideoUrl) },
            selectedTrailerRelay.asObservable())
        
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
                return LocalizedString.noMedia.localized
            default:
                return LocalizedString.video.localized
            }
        }
        
        showingTrailer = trailerVideoUrl.map { $0 != nil }
        
        isUploading = isUploadingSubject.asObservable()

        progress = uploadingProgressObservable.map { $0.totalProgress }
        
        /// We don't want the compact map version, handle different case upload progress
        progressText = dependencies.trailerUploadProgress.map { uploadProgress in
            guard let uploadProgress = uploadProgress else { return UploadProgress.initialProgressText }
            return uploadProgress.progressText
        }
        
        #warning("Maybe distinct until changed?")
        
        uploadComplete = dependencies.trailerUploadProgress
            .map { $0?.completed ?? false }
        
        let isProgressViewActive: Observable<Bool> = Observable.combineLatest(uploadComplete, isUploading) { uploadComplete, isUploading in
                return (uploadComplete || isUploading)
            }
        
        let hasSelectedNewTrailerAfterUpload = selectedNewTrailerRelay
            .withLatestFrom(uploadComplete)
            .filter { $0 == true }
            .map { _ in () }
        
        showProgressView = Observable.merge(isProgressViewActive, hasSelectedNewTrailerAfterUpload.map { _ in false })
        
        showUploadButton = showProgressView.map { !$0 }
        
        super.init(stateController: dependencies.stateController)
        
        #warning("Move subscribe to bind and then test")
        displayNameObservable
            .subscribe(onNext: { self.displayNameSubject.accept($0) })
            .disposed(by: disposeBag)
        
        biographyObservable
            .subscribe(onNext: { self.biographySubject.accept($0) })
            .disposed(by: disposeBag)
        
        emailObservable
            .subscribe(onNext: { self.emailSubject.accept($0) })
            .disposed(by: disposeBag)
        
        handleObservable
            .subscribe(onNext: { self.handleSubject.accept($0) })
            .disposed(by: disposeBag)
        
        #warning("Check whats happening here (Observe the full upload progess, likely isUploadingSubject is incorrect")
        
        uploadingProgressObservable
            .subscribe(onNext: { progress in
                print ("Progress: \(progress)")
            })
            .disposed(by: disposeBag)
        
        uploadComplete
            .subscribe(onNext: { complete in
                print ("Upload complete = \(complete)")
            })
            .disposed(by: disposeBag)

        isProgressViewActive
            .subscribe(onNext: { progressViewActive in
                print ("Result Active: \(progressViewActive)")
            })
            .disposed(by: disposeBag)
        
        hasSelectedNewTrailerAfterUpload
            .subscribe(onNext: { _ in
                print ("Has selected trailer after!")
            })
            .disposed(by: disposeBag)
        
        // #ENDTEST
        
        uploadingProgressObservable
            .map { !($0.completed || $0.failed) }
            .distinctUntilChanged()
            .bind(to: self.isUploadingSubject)
            .disposed(by: disposeBag)
        
        selectedTrailerRelay.compactMap { _ in true }
            .bind(to: selectedNewTrailerRelay)
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
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            schedulers: Schedulers.standard,
            profileUseCase: Domain.standard.useCases.profileUseCase,
            profileImage: Domain.standard.stateController.stateObservable(of: \.profileImage),
            profileObservable: Domain.standard.stateController.stateObservable(of: \.profile),
            trailerUploadProgress: Domain.standard.stateController.stateObservable(of: \.currentTrailerUploadProgress))
    }
}

// MARK: - Usecase functions

extension ProfileDetailViewModel {
    func updateProfile() {
        guard let displayName = displayNameSubject.value,
              let biography = biographySubject.value else { return }
        
        profileUseCase.updateProfile(displayName: displayName,
                                     biography: biography)
            .subscribe(onCompleted: {
                // Mark as update complete (loader)
                Logger.log(level: .info, topic: .debug, message: "Updated profile sucessfully!")
            }, onError: { [unowned self] error in
                self.stateController.sendError(error)
                Logger.log(level: .warning, topic: .debug, message: "Unable to update the broadcaster profile: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func profileImageSelected(withUrl url: URL) {
        if let image = UIImage(contentsOfFile: url.path) {
            profileUseCase.updateLocalProfile(image: image)
        }
        
        profileUseCase.updateProfile(image: url)
            .subscribe { _ in
            } onError: { error in
                self.stateController.sendError(error)
            } onCompleted: {
            }
            .disposed(by: disposeBag)
    }
    
    func trailerSelected(withUrl url: URL) {
        selectedTrailerRelay.accept(url)
    }
    
    func uploadTrailer(withUrl url: URL) {
        isUploadingSubject.onNext(true)
        profileUseCase.uploadTrailer(withUrl: url)
    }
}
