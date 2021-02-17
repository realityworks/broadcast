//
//  NewPostCreateViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 8/12/20.
//

import Foundation
import RxSwift
import RxCocoa
import AVKit
import SwiftRichString


class NewPostCreateViewModel : ViewModel {
    
    let schedulers: Schedulers
    let postContentUseCase: PostContentUseCase
    let persistenceService: PersistenceService
    
    private let selectedMediaSubject = BehaviorRelay<Media?>(value: nil)
    private let showTipsSubject = BehaviorRelay<Bool>(value: true)
    
    let title = BehaviorRelay<String>(value: "")
    let caption = BehaviorRelay<String>(value: "")
    
    // MARK: Pop back to view controller
    let popBackToMyPostsSignal = PublishRelay<()>()
    let popBackOnUploadComplete = PublishRelay<()>()
    
    let isActive = BehaviorRelay<Bool>(value: true)
    
    // MARK: Media Selection Properties
    let runTimeTitle: Observable<NSAttributedString>
    let mediaTypeTitle: Observable<String>
    
    private let isUploadingSubject = BehaviorSubject<Bool>(value: false)
    let canUpload: Observable<Bool>
    let isUploading: Observable<Bool>
    let progress: Observable<Float>
    let progressText: Observable<String>
    let selectedMedia: Observable<Media>
    let showingImage: Observable<Bool>
    let showingVideo: Observable<Bool>
    let showingMedia: Observable<Bool>
    
    let uploadComplete: Observable<Bool>
    
    let showProgressView: Observable<Bool>
    let showUploadButton: Observable<Bool>
    let showFailed: Observable<Bool>
            
    let showTips: Observable<Bool>
    
    init(dependencies: Dependencies = .standard) {
        self.schedulers = dependencies.schedulers
        self.postContentUseCase = dependencies.postContentUseCase
        self.persistenceService = dependencies.persistenceService
        
        postContentUseCase.prepareUploadMedia()
        
        let uploadingProgressObservable = dependencies.uploadProgressObservable.compactMap { $0 }
        
        progress = uploadingProgressObservable.map {
            print("TOTAL PROGRESS for new post: \($0.totalProgress)")
            return $0.totalProgress
        }
        progressText = dependencies.uploadProgressObservable.map { uploadProgress in
            guard let uploadProgress = uploadProgress else { return UploadProgress.initialProgressText }
            return uploadProgress.progressText
        }
        
        selectedMedia = selectedMediaSubject.compactMap { $0 }
        
        runTimeTitle = selectedMedia.map { media in
            switch media {
            case .video:
                return LocalizedString.duration.localized.set(style: Style.smallBody).set(style: Style.lightGrey) +
                    (" " + media.duration).set(style: Style.smallBody)
            case .image:
                return NSAttributedString(string: "")
            }
        }
        
        mediaTypeTitle = selectedMedia.map { media in
            switch media {
            case .video:
                return LocalizedString.video.localized
            case .image:
                return LocalizedString.image.localized
            }
        }
        
        showingImage = selectedMediaSubject.map {
            switch $0 {
            case .video, .none: return false
            case .image: return true
            }
        }
    
        showingVideo = selectedMediaSubject.map {
            switch $0 {
            case .image, .none: return false
            case .video: return true
            }
        }
        
        showingMedia = Observable.combineLatest(showingImage, showingVideo) { $0 || $1 }
        
        isUploading = isUploadingSubject.asObservable()
        uploadComplete = dependencies.uploadProgressObservable
            .map { $0?.completed ?? false }
        
        canUpload = Observable.combineLatest(
            isUploading,
            showingMedia,
            title.asObservable(),
            caption.asObservable()) { !$0 && $1 && !$2.isEmpty && !$3.isEmpty }
        
        showTips = showTipsSubject.asObservable()
        
        showProgressView = Observable.combineLatest(uploadComplete, isUploading) { uploadComplete, isUploading in
                return (uploadComplete || isUploading)
            }
        
        showUploadButton = showProgressView.map { !$0 }
        
        showFailed = dependencies.uploadProgressObservable.map { $0?.failed == true }
        
        super.init(stateController: dependencies.stateController)
        
        /// Bind when uploading progress observable changes and completed/failed are both false to correctly update the isUploadingSubject
        uploadingProgressObservable
            .map { !($0.completed || $0.failed) }
            .distinctUntilChanged()
            .bind(to: self.isUploadingSubject)
            .disposed(by: disposeBag)
        
        // If app is in background, wait until it is in foreground, otherwise proceed
        popBackOnUploadComplete
            .do(onNext: { _ in
                self.reloadPosts()
            })
            .delay(.milliseconds(1750), scheduler: schedulers.main)
            .subscribe(onNext: { success in
                self.popBackToMyPosts()
            })
            .disposed(by: disposeBag)
        
        if let tipsShown: Bool = self.persistenceService.read(key: PersistenceKeys.tipsShown) {
            showTipsSubject.accept(!tipsShown)
        } else {
            showTipsSubject.accept(true)
            persistenceService.write(value: true, forKey: PersistenceKeys.tipsShown)
        }
        
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
            .bind(to: popBackOnUploadComplete)
            .disposed(by: disposeBag)
    }
}

// MARK: - Dependencies

extension NewPostCreateViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let schedulers: Schedulers
        let persistenceService: PersistenceService
        
        let postContentUseCase: PostContentUseCase
        let uploadProgressObservable: Observable<UploadProgress?>
        
        let didBecomeActive: Observable<Void>
        let willResignActive: Observable<Void>
        
        static var standard: Dependencies {
            let notificationCenter = NotificationCenter.default.rx
            return Dependencies(
                stateController: Domain.standard.stateController,
                schedulers: Schedulers.standard,
                persistenceService: Services.standard.persistenceService,
                postContentUseCase: Domain.standard.useCases.postContentUseCase,
                uploadProgressObservable: Domain.standard.stateController.stateObservable(of: \.currentMediaUploadProgress),
                didBecomeActive: notificationCenter.notification(UIApplication.didBecomeActiveNotification).map { _ in () },
                willResignActive: notificationCenter.notification(UIApplication.willResignActiveNotification).map { _ in () })
        }
    }
}

// MARK: - Functions

extension NewPostCreateViewModel {
    func uploadPost() {
        guard let media = selectedMediaSubject.value else { return }
        
        // Compose post and upload
        isUploadingSubject.onNext(true)
        
        let newPost = PostContent(title: title.value, caption: caption.value)
        Logger.info(topic: .debug, message: "Upload new post : \(newPost) with media : \(media)")
        postContentUseCase.upload(content: newPost, media: media)
    }
    
    func selectMedia(_ media: Media) {
        selectedMediaSubject.accept(media)
    }
    
    func removeMedia() {
        selectedMediaSubject.accept(nil)
    }
    
    func showTips(_ show: Bool) {
        showTipsSubject.accept(show)
    }
    
    func cancel() {
        title.accept("")
        caption.accept("")
        removeMedia()
    }
    
    func reloadPosts() {
        postContentUseCase.retrieveMyPosts()
    }
    
    func popBackToMyPosts() {
        popBackToMyPostsSignal.accept(())
    }
}
