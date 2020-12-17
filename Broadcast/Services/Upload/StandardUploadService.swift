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

struct StandardUploadProgress

class StandardUploadService : {
    
    let baseUrl: URL
    let uploadSession: Session
    let schedulers: Schedulers
    
    var apiService: APIService?
    var media: Media?
    var content: PostContent?
    var uploadProgressPublishSubject: PublishSubject<UploadProgress>?
    
    // MARK: - UploadProgress
    var postId: PostID? {
        didSet {
            uploadProgressPublishSubject?.onNext(self)
        }
    }
    var mediaId: MediaID? 
    var sourceUrl: URL?
    var destinationURL: URL?
    var progress: Float
    
    init(dependencies: Dependencies = .standard) {
        self.media = nil
        self.content = nil
        self.uploadProgressPublishSubject = nil
        
        self.baseUrl = dependencies.baseUrl
        self.schedulers = dependencies.schedulers
        self.uploadSession = Session.default
        
        self.postId = nil
        self.mediaId = nil
        self.sourceUrl = nil
        self.destinationURL = nil
        self.progress = 0
        
        
    }
}

// MARK: - Standard upload service

extension StandardUploadService : UploadService {
    
    func inject(apiService: APIService) {
        self.apiService = apiService
    }
    
    func upload(media: Media, content: PostContent) -> Observable<UploadProgress>? {
        guard let apiService = apiService else { return nil }
        self.media = media
        self.content = content
        
        uploadProgressPublishSubject = PublishSubject<UploadProgress>()

        let createPostObservable = Observable<UploadEvent>.create { observer in
            self.apiService?.createPost()
                .subscribe(onSuccess: { response in
                    observer.onNext(UploadEvent.createPost(postId: response.postId))
                }, onError: { error in
                    observer.onError(BoomdayError.uploadFailed(UploadEvent.createPost(postId: "")))
                })
            
            return Disposables.create()
        }
        
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
        
        createPostObservable
            .flatMap { response -> Single<Result> in
                <#code#>
            }
        guard let postId = postId,
            let media = stateController.state.selectedMedia else { return }
            
        apiService.getUploadUrl(forPostID: postId, for: media)
//                .subscribe { [weak self] response in
//                    print(response)
//                    self?.mediaId = response.mediaId
//                    self?.uploadUrl = URL(string: response.uploadUrl)
//                } onError: { error in
//                    print(error)
//                }
//                .disposed(by: disposeBag)
        
        guard
            let selectedMedia = stateController.state.selectedMedia,
            case Media.video(let url) = selectedMedia,
            let uploadUrl = uploadUrl else { return }
        apiService.uploadVideo(from: url, to: uploadUrl)
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
        
        guard let postId = postId,
              let mediaId = mediaId else { return }
        apiService.mediaComplete(for: postId, mediaId)
//                .subscribe {
//                    print ("FINALIZED MEDIA UPLOAD COMPLETE")
//                } onError: { error in
//                    print (error)
//                }
//                .disposed(by: disposeBag)
        
        guard let postId = postId else { return }
        let newPost = PostContent(title: title.value, caption: caption.value)
        apiService.updatePostContent(
                postId: postId,
                newContent: newPost)
//                .subscribe {
//                    print ("CONTENT SET")
//                } onError: { error in
//                    print (error)
//                }
//                .disposed(by: disposeBag)
        
        guard let postId = postId else { return }
        apiService.publish(postId: postId)
            .subscribe {
                print ("PUBLISHED POST!")
            } onError: { error in
                print (error)
            }
            .disposed(by: disposeBag)
        
        return uploadProgressPublishSubject!
            .asObservable()
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
