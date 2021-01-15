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
    
    let postContentUseCase: PostContentUseCase
    
    private let selectedMediaSubject = BehaviorRelay<Media?>(value: nil)
    private let showTipsSubject = BehaviorRelay<Bool>(value: true)
    
    let title = BehaviorRelay<String>(value: "")
    let caption = BehaviorRelay<String>(value: "")
    
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
        
    let showTips: Observable<Bool>
    
    init(dependencies: Dependencies = .standard) {
        self.postContentUseCase = dependencies.postContentUseCase
        
        let uploadingProgressObservable = dependencies.uploadProgressObservable.compactMap { $0 }
        
        progress = uploadingProgressObservable.map { $0.totalProgress }
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
        
        super.init(stateController: dependencies.stateController)
        
        /// Bind when uploading progress observable changes and completed/failed are both false to correctly update the isUploadingSubject
        uploadingProgressObservable
            .map { !($0.completed || $0.failed) }
            .distinctUntilChanged()
            .bind(to: self.isUploadingSubject)
            .disposed(by: disposeBag)
    }
}

// MARK: - Dependencies

extension NewPostCreateViewModel {
    struct Dependencies {
        
        let stateController: StateController
        let postContentUseCase: PostContentUseCase
        let uploadProgressObservable: Observable<UploadProgress?>
        
        static let standard = Dependencies(
            stateController: Domain.standard.stateController,
            postContentUseCase: Domain.standard.useCases.postContentUseCase,
            uploadProgressObservable: Domain.standard.stateController.stateObservable(of: \.currentMediaUploadProgress))
    }
}

// MARK: - Functions

extension NewPostCreateViewModel {
    func uploadPost() {
        guard let media = selectedMediaSubject.value else { return }
        
        // Compose post and upload
        isUploadingSubject.onNext(true)
        
        let newPost = PostContent(title: title.value, caption: caption.value)
        postContentUseCase.upload(content: newPost, media: media)
    }
    
    func selectMedia(_ media: Media) {
        selectedMediaSubject.accept(media)
    }
    
    func showTips(_ show: Bool) {
        showTipsSubject.accept(show)
    }
    
    func clearContent() {
        title.accept("")
        caption.accept("")
        removeMedia()
    }
}
