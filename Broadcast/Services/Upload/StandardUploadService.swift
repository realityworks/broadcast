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
    
    let uploadTrailerFileSession = MediaUploadSession(withIdentifier: "trailer.background.session")
    let uploadMediaFileSession = MediaUploadSession(withIdentifier: "media.background.session")

    var uploadMediaProgress = UploadProgress()
    var uploadTrailerProgress = UploadProgress()
    
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
        
        uploadMediaProgress = UploadProgress()
        uploadMediaProgress.sourceUrl = media.url
        
        // Setup the Create Post observable
        let createPostObservable = Observable<UploadEvent>.create { [unowned self] observer in
            apiService.createPost()
                .subscribe(onSuccess: { response in
                    observer.onNext(UploadEvent.createPost(postId: response.postId))
                    observer.onCompleted()
                }, onFailure: { error in
                    observer.onError(BoomdayError.uploadFailed(UploadEvent.createPost(postId: nil)))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
        
        // Get the upload URL
        let getMediaUploadUrlObservable = Observable<UploadEvent>.create { [unowned self] observer in
            if let postId = self.uploadMediaProgress.postId,
               let media = self.media {
                apiService.getMediaUploadUrl(forPostID: postId, for: media)
                    .subscribe(onSuccess: { response in
                        observer.onNext(UploadEvent.requestPostUploadUrl(uploadUrl: URL(string: response.uploadUrl), mediaId: response.mediaId))
                        observer.onCompleted()
                    }, onFailure: { error in
                        observer.onError(
                            BoomdayError.uploadFailed(UploadEvent.requestPostUploadUrl(uploadUrl: nil, mediaId: nil)))
                    })
                    .disposed(by: self.disposeBag)
            } else {
                observer.onError(
                    BoomdayError.uploadFailed(UploadEvent.requestPostUploadUrl(uploadUrl: nil, mediaId: nil)))
            }

            return Disposables.create()
        }
        
        // Upload the media to the blob
        let uploadMediaObservable = Observable<UploadEvent>.create { [unowned self] observer in
            if let sourceUrl = self.uploadMediaProgress.sourceUrl,
               let destinationUrl = self.uploadMediaProgress.destinationURL {
                apiService.uploadMedia(from: sourceUrl,
                                       to: destinationUrl)
                        .subscribe { response, progress in
                            let progressFloat = Float(progress.bytesWritten) / Float(progress.totalBytes)
                            observer.onNext(
                                UploadEvent.uploadMedia(progress: progressFloat))
                        } onError: { error in
                            observer.onError(BoomdayError.unknown)
                        } onCompleted: {
                            observer.onCompleted()
                        } onDisposed: {
                        }
                        .disposed(by: disposeBag)
            } else {
                observer.onError(BoomdayError.unknown)
            }

            return Disposables.create()
        }
        
        // Trigger complete upload
        let completeUploadObservable = Observable<UploadEvent>.create { [unowned self] observer in
            if let postId = self.uploadMediaProgress.postId,
               let mediaId = self.uploadMediaProgress.mediaId {
                apiService.uploadMediaComplete(for: postId, mediaId)
                        .subscribe {
                            Logger.log(level: .verbose, topic: .debug, message:  "FINALIZED MEDIA UPLOAD COMPLETE")
                            observer.onNext(UploadEvent.completeUpload)
                            observer.onCompleted()
                        } onError: { error in
                            observer.onError(BoomdayError.unknown)
                        }
                        .disposed(by: disposeBag)
            } else {
                observer.onError(BoomdayError.unknown)
            }
            
            return Disposables.create()
        }
        
        // Set the post content
        let setContentObservable = Observable<UploadEvent>.create { [unowned self] observer in
            if let postId = self.uploadMediaProgress.postId {
                apiService.updatePostContent(
                    postId: postId,
                    newContent: content)
                    .subscribe {
                        Logger.log(level: .verbose, topic: .debug, message: "CONTENT SET")
                        observer.onNext(UploadEvent.postContent)
                        observer.onCompleted()
                    } onError: { error in
                        observer.onError(BoomdayError.publishFailed)
                    }
                    .disposed(by: disposeBag)
            } else {
                observer.onError(BoomdayError.unknown)
            }
            
            return Disposables.create()
        }
        
        // Set the post content
        let publishContentObservable = Observable<UploadEvent>.create { [unowned self] observer in
            if let postId = self.uploadMediaProgress.postId {
                apiService.publish(postId: postId)
                    .subscribe {
                        Logger.log(level: .verbose, topic: .debug, message: "PUBLISHED")
                        observer.onNext(UploadEvent.publish)
                        observer.onCompleted()
                    } onError: { error in
                        observer.onError(BoomdayError.publishFailed)
                    }
                    .disposed(by: disposeBag)
            } else {
                observer.onError(BoomdayError.unknown)
            }
            
            return Disposables.create()
        }
        
        return Observable.concat(createPostObservable,
                                 getMediaUploadUrlObservable,
                                 uploadMediaObservable,
                                 completeUploadObservable,
                                 setContentObservable,
                                 publishContentObservable)
            .map { event -> UploadProgress in
                switch event {
                case .createPost(let postId):
                    self.uploadMediaProgress.postId = postId
                    self.uploadMediaProgress.progress += 0.05
                    self.uploadMediaProgress.totalProgress += 0.05
                    
                case .requestPostUploadUrl(let uploadUrl, let mediaId):
                    self.uploadMediaProgress.mediaId = mediaId
                    self.uploadMediaProgress.destinationURL = uploadUrl
                    self.uploadMediaProgress.progress += 0.05
                    self.uploadMediaProgress.totalProgress += 0.05
                
                case .uploadMedia(let progress):
                    self.uploadMediaProgress.uploadProgress = progress
                    self.uploadMediaProgress.totalProgress =
                        self.uploadMediaProgress.progress + (progress * 0.75)
                case .completeUpload:
                    self.uploadMediaProgress.progress += 0.05
                    self.uploadMediaProgress.totalProgress += 0.05
                case .postContent:
                    self.uploadMediaProgress.progress += 0.05
                    self.uploadMediaProgress.totalProgress += 0.05
                case .publish:
                    self.uploadMediaProgress.progress += 0.05
                    self.uploadMediaProgress.totalProgress += 0.05
                default:
                    throw BoomdayError.unknown
                }
                
                return self.uploadMediaProgress
            }
    }
    
    func uploadTrailer(from url: URL) -> Observable<UploadProgress> {
        guard let apiService = apiService else { return .error(BoomdayError.unknown) }
        
        uploadTrailerProgress = UploadProgress()
        uploadTrailerProgress.sourceUrl = url

        
        // Get the upload URL
        let getUploadUrlObservable = Observable<UploadEvent>.create { [unowned self] observer in
            apiService.getTrailerUploadUrl()
                .subscribe(onSuccess: { response in
                    observer.onNext(UploadEvent.requestTrailerUploadUrl(uploadUrl: URL(string: response.uploadUrl)))
                    observer.onCompleted()
                }, onFailure: { error in
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
        
        // Upload the media to the blob
        let uploadTrailerObservable = Observable<UploadEvent>.create { [unowned self] observer in
            if let sourceUrl = self.uploadTrailerProgress.sourceUrl,
               let destinationUrl = self.uploadTrailerProgress.destinationURL {
                apiService.uploadMedia(from: sourceUrl,
                                       to: destinationUrl)
                        .subscribe { response, progress in
                            let progressFloat = Float(progress.bytesWritten) / Float(progress.totalBytes)
                            observer.onNext(
                                UploadEvent.uploadMedia(progress: progressFloat))
                        } onError: { error in
                            observer.onError(BoomdayError.unknown)
                        } onCompleted: {
                            observer.onCompleted()
                        } onDisposed: {
                        }
                        .disposed(by: disposeBag)
            } else {
                observer.onError(BoomdayError.unknown)
            }

            return Disposables.create()
        }
        
        // Trigger complete upload
        let completeUploadObservable = Observable<UploadEvent>.create { [unowned self] observer in
            apiService.uploadTrailerComplete()
                    .subscribe {
                        Logger.log(level: .verbose, topic: .debug, message:  "FINALIZED MEDIA UPLOAD COMPLETE")
                        observer.onNext(UploadEvent.completeUpload)
                        observer.onCompleted()
                    } onError: { error in
                        print (error)
                        observer.onError(BoomdayError.unknown)
                    }
                    .disposed(by: disposeBag)
            
            return Disposables.create()
        }
        
        return Observable.concat(getUploadUrlObservable,
                                 uploadTrailerObservable,
                                 completeUploadObservable)
            .map { event -> UploadProgress in
                switch event {
                case .requestTrailerUploadUrl(let uploadUrl):
                    self.uploadTrailerProgress.destinationURL = uploadUrl
                    self.uploadTrailerProgress.progress += 0.05
                    self.uploadTrailerProgress.totalProgress += 0.05
                
                case .uploadMedia(let progress):
                    self.uploadTrailerProgress.uploadProgress = progress
                    self.uploadTrailerProgress.totalProgress =
                        self.uploadTrailerProgress.progress + (progress * 0.9)
                case .completeUpload:
                    self.uploadTrailerProgress.progress += 0.05
                    self.uploadTrailerProgress.totalProgress += 0.05
                default:
                    throw BoomdayError.unknown
                }
                
                return self.uploadTrailerProgress
            }
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
