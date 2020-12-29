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
    private let uploadingSubject = BehaviorSubject<Bool>(value: false)
    
    let title = BehaviorRelay<String>(value: "")
    let caption = BehaviorRelay<String>(value: "")
    
    let viewTimeTitle: Observable<NSAttributedString>
    let mediaTypeTitle: Observable<String>
    
    let canUpload: Observable<Bool>
    let isUploading: Observable<Bool>
    let progress: Observable<Float>
    let selectedMedia: Observable<Media>
    let showingImage: Observable<Bool>
    let showingVideo: Observable<Bool>
    let showingMedia: Observable<Bool>
    
    init(dependencies: Dependencies = .standard) {
        self.postContentUseCase = dependencies.postContentUseCase
        
        let uploadingProgressObservable = dependencies.uploadProgressObservable.compactMap { $0 }
        
        progress = uploadingProgressObservable.map { $0.totalProgress }
        isUploading = uploadingSubject.asObservable()
        selectedMedia = selectedMediaSubject.compactMap { $0 }
        
        viewTimeTitle = selectedMedia.map { media in
            switch media {
            case .video:
                return LocalizedString.duration.localized.set(style: Style.smallBodyGrey) +
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
        
        canUpload = Observable.combineLatest(
            isUploading,
            showingMedia,
            title.asObservable(),
            caption.asObservable()) {
            print ("Is Uploading : \($0), showingMedia: \($1), title empty: \($2.isEmpty), caption empty: \($3.isEmpty)")
                return !$0 && $1 && !$2.isEmpty && !$3.isEmpty
        }
        
        super.init(stateController: dependencies.stateController)
        
        uploadingProgressObservable
            .map { !$0.completed }
            .distinctUntilChanged()
            .bind(to: self.uploadingSubject)
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
            uploadProgressObservable: Domain.standard.stateController.stateObservable(of: \.currentUploadProgress))
    }
}

// MARK: - Functions

extension NewPostCreateViewModel {
    func uploadPost() {
        guard let media = selectedMediaSubject.value else { return }
        
        // Compose post and upload
        uploadingSubject.onNext(true)
        
        let newPost = PostContent(title: title.value, caption: caption.value)
        postContentUseCase.upload(content: newPost, media: media)
    }
    
    func selectMedia(_ media: Media) {
        selectedMediaSubject.accept(media)
    }
    
    func removeMedia() {
        selectedMediaSubject.accept(nil)
    }
}
