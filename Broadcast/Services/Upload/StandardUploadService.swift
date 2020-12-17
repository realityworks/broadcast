//
//  StandardUploadService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire


class StandardUploadService {
    
    let baseUrl: URL
    let uploadSession: Session
    let schedulers: Schedulers
    
    var apiService: APIService?
    var media: Media?
    var content: PostContent?

    var uploadProgress = StandardUploadProgress()
    
    let disposeBag = DisposeBag()
    
    // MARK: - UploadProgress
    
    init(dependencies: Dependencies = .standard) {
        self.media = nil
        self.content = nil
        
        self.baseUrl = dependencies.baseUrl
        self.schedulers = dependencies.schedulers
        self.uploadSession = Session.default
    }
}

// MARK: - Standard upload service

extension StandardUploadService : UploadService {
    
    func inject(apiService: APIService) {
        self.apiService = apiService
    }
    
    func upload(media: Media, content: PostContent) -> Observable<UploadProgress> {
        guard let apiService = apiService else { return .error(BoomdayError.unknown) }
        
        self.media = media
        self.content = content
        
        uploadProgress = StandardUploadProgress()
        
        // Setup the Create Post observable
        let createPostObservable = Observable<UploadEvent>.create { [unowned self] observer in
            apiService.createPost()
                .subscribe(onSuccess: { response in
                    observer.onNext(UploadEvent.createPost(postId: response.postId))
                }, onError: { error in
                    observer.onError(BoomdayError.uploadFailed(UploadEvent.createPost(postId: nil)))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
        let getUploadUrlObservable = Observable<UploadEvent>.create { [unowned self] observer in
            if let postId = self.uploadProgress.postId,
               let media = self.media {
                apiService.getUploadUrl(forPostID: postId, for: media)
                    .subscribe(onSuccess: { response in
                        observer.onNext(UploadEvent.requestUploadUrl(uploadUrl: URL(string: response.uploadUrl), mediaId: response.mediaId))
                    }, onError: { error in
                        observer.onError(BoomdayError.uploadFailed(UploadEvent.requestUploadUrl(uploadUrl: nil, mediaId: nil)))
                    })
                    .disposed(by: self.disposeBag)
            } else {
                observer.onError(BoomdayError.unknown)
            }

            return Disposables.create()
        }
        
        return Observable.concat(createPostObservable, getUploadUrlObservable)
            .map { event -> UploadProgress in
                switch event {
                case .createPost(let postId):
                    print("CREATE POST")
                    self.uploadProgress.postId = postId
                    self.uploadProgress.progress += 0.1
                    
                case .requestUploadUrl(let uploadUrl, let mediaId):
                    print("REQUEST UPLOAD URL")
                    self.uploadProgress.destinationURL = uploadUrl
                    self.uploadProgress.mediaId = mediaId
                    self.uploadProgress.progress += 0.1
                    
                default:
                    break
                }
                
                return self.uploadProgress
            }
        
        //return uploadProgressPublishSubject?.asObservable()
        
//        let createPostObservable = apiService.createPost()
//            .flatMap { [unowned self] response -> Single<GetUploadUrlResponse> in
//                self.postId = response.postId
//                return apiService.getUploadUrl(forPostID: response.postId, for: media)
//            }
//            .asObservable()
//            .flatMap { [unowned self] response -> Observable<(HTTPURLResponse, RxProgress)> in
//                self.mediaId = response.mediaId
//                if case Media.video(let sourceUrl) = media,
//                   let uploadUrl = URL(string: response.uploadUrl) {
//                    return apiService.uploadVideo(from: sourceUrl, to: uploadUrl)
//                }
//                return .error(BoomdayError.unsupported)
//            }
//            .do { response, progress in
//                print ("PROGRESS : \(progress.bytesWritten) / \(progress.totalBytes)")
//            }
//            .concat { [unowned self] _ in
//                return apiService.mediaComplete(for: self.postId!, self.mediaId!)
//            }
            //.flatMap { _ in }
//            .flatMap { response, progress in
//
//            }
        
            //.map { UploadEvent.createPost(postId: $0.postId) }
            //.asObservable()
        
//            .subscribe { [weak self] response in
//                print(response)
//                self?.postId = response.postId
//            } onError: { error in
//                print(error)
//            }
//            .disposed(by: disposeBag)
        
//        createPostObservable
//            .flatMap { response -> Single<Result> in
//                <#code#>
//            }
//        guard let postId = postId,
//            let media = stateController.state.selectedMedia else { return }
//
//        apiService.getUploadUrl(forPostID: postId, for: media)
//                .subscribe { [weak self] response in
//                    print(response)
//                    self?.mediaId = response.mediaId
//                    self?.uploadUrl = URL(string: response.uploadUrl)
//                } onError: { error in
//                    print(error)
//                }
//                .disposed(by: disposeBag)
        
//        guard
//            let selectedMedia = stateController.state.selectedMedia,
//            case Media.video(let url) = selectedMedia,
//            let uploadUrl = uploadUrl else { return }
//        apiService.uploadVideo(from: url, to: uploadUrl)
//            .subscribe { response, progress in
//                print ("PROGRESS : \(progress.bytesWritten) / \(progress.totalBytes)")
//            } onError: { error in
//                print ("ERROR: \(error)")
//            } onCompleted: {
//                print ("COMPLETED!")
//            } onDisposed: {
//                print ("DISPOSED!")
//            }
//            .disposed(by: disposeBag)
        
//        guard let postId = postId,
//              let mediaId = mediaId else { return }
//        apiService.mediaComplete(for: postId, mediaId)
//                .subscribe {
//                    print ("FINALIZED MEDIA UPLOAD COMPLETE")
//                } onError: { error in
//                    print (error)
//                }
//                .disposed(by: disposeBag)
        
//        guard let postId = postId else { return }
//        let newPost = PostContent(title: title.value, caption: caption.value)
//        apiService.updatePostContent(
//                postId: postId,
//                newContent: newPost)
//                .subscribe {
//                    print ("CONTENT SET")
//                } onError: { error in
//                    print (error)
//                }
//                .disposed(by: disposeBag)
        
//        guard let postId = postId else { return }
//        apiService.publish(postId: postId)
//            .subscribe {
//                print ("PUBLISHED POST!")
//            } onError: { error in
//                print (error)
//            }
//            .disposed(by: disposeBag)
    }
}

// MARK: Instance Dependencies

extension StandardUploadService {
    
    static let standard = {
        StandardUploadService()
    }()
}


// MARK: Dependencies
extension StandardUploadService {
    struct Dependencies {
        
        let schedulers: Schedulers
        let baseUrl: URL
        
        static let standard = Dependencies(
            schedulers: Schedulers.standard,
            baseUrl: Configuration.apiServiceURL)
    }
}
