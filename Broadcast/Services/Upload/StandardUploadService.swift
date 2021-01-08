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

    var uploadProgress = UploadProgress()
    
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
        
        uploadProgress = UploadProgress()
        uploadProgress.sourceUrl = media.url
        
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
            if let postId = self.uploadProgress.postId,
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
            if let sourceUrl = self.uploadProgress.sourceUrl,
               let destinationUrl = self.uploadProgress.destinationURL {
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
            if let postId = self.uploadProgress.postId,
               let mediaId = self.uploadProgress.mediaId {
                apiService.mediaComplete(for: postId,
                                         mediaId)
                        .subscribe {
                            Logger.log(level: .verbose, topic: .debug, message:  "FINALIZED MEDIA UPLOAD COMPLETE")
                            observer.onNext(UploadEvent.completeUpload)
                            observer.onCompleted()
                        } onError: { error in
                            print (error)
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
            if let postId = self.uploadProgress.postId {
                apiService.updatePostContent(
                    postId: postId,
                    newContent: content)
                    .subscribe {
                        Logger.log(level: .verbose, topic: .debug, message: "CONTENT SET")
                        observer.onNext(UploadEvent.postContent)
                        observer.onCompleted()
                    } onError: { error in
                        print (error)
                    }
                    .disposed(by: disposeBag)
            } else {
                observer.onError(BoomdayError.unknown)
            }
            
            return Disposables.create()
        }
        
        // Set the post content
        let publishContentObservable = Observable<UploadEvent>.create { [unowned self] observer in
            if let postId = self.uploadProgress.postId {
                apiService.publish(postId: postId)
                    .subscribe {
                        Logger.log(level: .verbose, topic: .debug, message: "PUBLISHED")
                        observer.onNext(UploadEvent.publish)
                        observer.onCompleted()
                    } onError: { error in
                        print (error)
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
                    self.uploadProgress.postId = postId
                    self.uploadProgress.progress += 0.05
                    self.uploadProgress.totalProgress += 0.05
                    
                case .requestPostUploadUrl(let uploadUrl, let mediaId):
                    self.uploadProgress.mediaId = mediaId
                    self.uploadProgress.destinationURL = uploadUrl
                    self.uploadProgress.progress += 0.05
                    self.uploadProgress.totalProgress += 0.05
                
                case .uploadMedia(let progress):
                    self.uploadProgress.uploadProgress = progress
                    self.uploadProgress.totalProgress =
                        self.uploadProgress.progress + (progress * 0.75)
                case .completeUpload:
                    self.uploadProgress.progress += 0.05
                    self.uploadProgress.totalProgress += 0.05
                case .postContent:
                    self.uploadProgress.progress += 0.05
                    self.uploadProgress.totalProgress += 0.05
                case .publish:
                    self.uploadProgress.progress += 0.05
                    self.uploadProgress.totalProgress += 0.05
                default:
                    throw BoomdayError.unknown
                }
                
                return self.uploadProgress
            }
    }
    
    func uploadTrailer(videoFileUrl: URL) -> Observable<UploadProgress> {
        guard let apiService = apiService else { return .error(BoomdayError.unknown) }
        
        // Get the upload URL
        let getUploadUrlObservable = Observable<UploadEvent>.create { [unowned self] observer in
            apiService.getTrailerUploadUrl()
                .subscribe(onSuccess: { response in
                    observer.onNext(UploadEvent.requestTrailerUploadUrl(uploadUrl: URL(string: response.uploadUrl)))
                    observer.onCompleted()
                }, onFailure: { error in
                    observer.onError(
                        BoomdayError.uploadFailed(UploadEvent.requestTrailerUploadUrl(uploadUrl: nil)))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
        
        // Upload the media to the blob
        let uploadMediaObservable = Observable<UploadEvent>.create { [unowned self] observer in
            if let sourceUrl = self.uploadProgress.sourceUrl,
               let destinationUrl = self.uploadProgress.destinationURL {
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
            if let postId = self.uploadProgress.postId,
               let mediaId = self.uploadProgress.mediaId {
                apiService.mediaComplete(for: postId,
                                         mediaId)
                        .subscribe {
                            Logger.log(level: .verbose, topic: .debug, message:  "FINALIZED MEDIA UPLOAD COMPLETE")
                            observer.onNext(UploadEvent.completeUpload)
                            observer.onCompleted()
                        } onError: { error in
                            print (error)
                            observer.onError(BoomdayError.unknown)
                        }
                        .disposed(by: disposeBag)
            } else {
                observer.onError(BoomdayError.unknown)
            }
            
            return Disposables.create()
        }
        
        return Observable.concat(getUploadUrlObservable,
                                 uploadMediaObservable,
                                 completeUploadObservable)
            .map { event -> UploadProgress in
                switch event {
                case .requestTrailerUploadUrl(let uploadUrl):
                    self.uploadProgress.destinationURL = uploadUrl
                    self.uploadProgress.progress += 0.05
                    self.uploadProgress.totalProgress += 0.05
                
                case .uploadMedia(let progress):
                    self.uploadProgress.uploadProgress = progress
                    self.uploadProgress.totalProgress =
                        self.uploadProgress.progress + (progress * 0.9)
                case .completeUpload:
                    self.uploadProgress.progress += 0.05
                    self.uploadProgress.totalProgress += 0.05
                default:
                    throw BoomdayError.unknown
                }
                
                return self.uploadProgress
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
