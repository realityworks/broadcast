//
//  StandardUploadService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit
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
    
    static let uploadTrailerFileSession = MediaUploadSession(withIdentifier: "background.session.trailer")
    static let uploadMediaFileSession = MediaUploadSession(withIdentifier: "background.session.media")

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
    
    func upload(media uploadMedia: Media, content: PostContent) -> Observable<UploadProgress> {
        guard let apiService = apiService else { return .error(BoomdayError.unknown) }
        
        /// Performing a check if image or video, if a video, we need to save out to a local file.
        do {
            media = try uploadMedia.localCopy(withFilename: "media")
        } catch {
            return .error(error)
        }
        
        guard let media = media else {
            return .error(BoomdayError.internalMemoryError(text: "Internal failure for media, you might need to clear more space"))
        }
        
        uploadMediaProgress = UploadProgress()
        uploadMediaProgress.sourceUrl = media.url
        
        // Setup the Create Post observable
        let createPostObservable = Observable<UploadEvent>.create { [unowned self] observer in
            apiService.createPost()
                .subscribe(onSuccess: { response in
                    Logger.info(topic: .debug, message: "Created Post with ID : \(response.postId)")
                    observer.onNext(UploadEvent.createPost(postId: response.postId))
                    observer.onCompleted()
                }, onFailure: { error in
                    Logger.warning(topic: .debug, message: "Create Post failed : \(error)")
                    observer.onError(error)
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
                        Logger.info(topic: .api,
                                    message: "Media Upload Ready for URL : \(response.uploadUrl) for media : \(response.mediaId)")
                        observer.onNext(UploadEvent.requestPostUploadUrl(uploadUrl: URL(string: response.uploadUrl), mediaId: response.mediaId))
                        observer.onCompleted()
                    }, onFailure: { error in
                        Logger.warning(topic: .debug, message: "Get media upload URL failed : \(error)")
                        observer.onError(error)
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
            Logger.log(level: .verbose, topic: .debug, message:  "Begin upload media")
            if let sourceUrl = self.uploadMediaProgress.sourceUrl,
               let destinationUrl = self.uploadMediaProgress.destinationURL {
                StandardUploadService.uploadMediaFileSession.start(from: sourceUrl,
                                             to: destinationUrl)
                { sent, total in
                    let progressFloat = total > 0 ? Float(sent) / Float(total) : 0
                    observer.onNext(UploadEvent.uploadMedia(progress: progressFloat))
                } onComplete: {
                    Logger.info(topic: .debug, message:  "Completed upload")
                    observer.onCompleted()
                } onFailure: { error in
                    Logger.warning(topic: .debug, message: "Media upload failed : \(error)")
                    observer.onError(error)
                }
            } else {
                observer.onError(BoomdayError.unknown)
            }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
        // Trigger complete upload
        let completeUploadObservable = Observable<UploadEvent>.create { [unowned self] observer in
            Logger.log(level: .verbose, topic: .debug, message:  "Begin upload media completion")
            if let postId = self.uploadMediaProgress.postId,
               let mediaId = self.uploadMediaProgress.mediaId {
                apiService.uploadMediaComplete(for: postId, mediaId)
                        .subscribe {
                            Logger.log(level: .verbose, topic: .debug, message:  "Finalized media upload complete")
                            observer.onNext(UploadEvent.completeUpload)
                            observer.onCompleted()
                        } onError: { error in
                            Logger.info(topic: .debug, message: "Media Complete Failed : \(error)")
                            observer.onError(error)
                        }
                        .disposed(by: disposeBag)
            } else {
                observer.onError(BoomdayError.unknown)
            }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
        // Set the post content
        let setContentObservable = Observable<UploadEvent>.create { [unowned self] observer in
            if let postId = self.uploadMediaProgress.postId {
                apiService.updatePostContent(
                    postId: postId,
                    newContent: content)
                    .subscribe {
                        Logger.log(level: .verbose, topic: .debug, message: "Update Content Succesful")
                        observer.onNext(UploadEvent.postContent)
                        observer.onCompleted()
                    } onError: { error in
                        Logger.info(topic: .debug, message: "Update post content failed : \(error)")
                        observer.onError(error)
                    }
                    .disposed(by: disposeBag)
            } else {
                observer.onError(BoomdayError.unknown)
            }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
        // Set the post content
        let publishContentObservable = Observable<UploadEvent>.create { [unowned self] observer in
            if let postId = self.uploadMediaProgress.postId {
                apiService.publish(postId: postId)
                    .subscribe {
                        Logger.log(level: .verbose, topic: .debug, message: "Publish Content Successful")
                        observer.onNext(UploadEvent.publish)
                        observer.onCompleted()
                    } onError: { error in
                        Logger.info(topic: .debug, message: "Publish post content failed : \(error)")
                        observer.onError(BoomdayError.publishFailed)
                    }
                    .disposed(by: disposeBag)
            } else {
                observer.onError(BoomdayError.unknown)
            }
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
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
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    func uploadTrailer(from url: URL) -> Observable<UploadProgress> {
        guard let apiService = apiService else { return .error(BoomdayError.unknown) }

        uploadTrailerProgress = UploadProgress()
        
        do {
            uploadTrailerProgress.sourceUrl = try url.copiedToLocal(filename: "trailer")
        } catch {
            return .error(error)
        }

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
                StandardUploadService.uploadTrailerFileSession.start(from: sourceUrl,
                                             to: destinationUrl)
                { sent, total in
                    let progressFloat = total > 0 ? Float(sent) / Float(total) : 0
                    observer.onNext(UploadEvent.uploadMedia(progress: progressFloat))
                } onComplete: {
                    Logger.log(level: .verbose, topic: .debug, message:  "Completed upload")
                    observer.onCompleted()
                } onFailure: { error in
                    observer.onError(error)
                }
            } else {
                observer.onError(BoomdayError.unknown)
            }

            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
        // Trigger complete upload
        let completeUploadObservable = Observable<UploadEvent>.create { [unowned self] observer in
            apiService.uploadTrailerComplete()
                    .subscribe {
                        Logger.log(level: .verbose, topic: .debug, message:  "FINALIZED MEDIA UPLOAD COMPLETE")
                        observer.onNext(UploadEvent.completeUpload)
                        observer.onCompleted()
                    } onError: { error in
                        observer.onError(BoomdayError.unknown)
                    }
                    .disposed(by: disposeBag)
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        
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
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
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
