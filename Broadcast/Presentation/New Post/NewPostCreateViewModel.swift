//
//  NewPostCreateViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 8/12/20.
//

import Foundation
import RxSwift
import RxCocoa


class NewPostCreateViewModel : ViewModel {
    
    let postContentUseCase: PostContentUseCase
    
    let title = BehaviorRelay<String>(value: "")
    let caption = BehaviorRelay<String>(value: "")
    
    private let uploadingSubject = BehaviorSubject<Bool>(value: false)
    let isUploading: Observable<Bool>
    let progress: Observable<Float>
    
    init(dependencies: Dependencies = .standard) {
        self.postContentUseCase = dependencies.postContentUseCase
        
        let uploadingProgressObservable = dependencies.uploadProgressObservable.compactMap { $0 }
        
        progress = uploadingProgressObservable.map { $0.totalProgress }
        isUploading = uploadingSubject.asObservable()
        
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
        // Compose post and upload
        uploadingSubject.onNext(true)
        
        let newPost = PostContent(title: title.value, caption: caption.value)
        postContentUseCase.upload(content: newPost)
    }
}
