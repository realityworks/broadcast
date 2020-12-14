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

class StandardUploadService : UploadService {
    
    let baseUrl: URL
    let uploadSession: Session
    let schedulers: Schedulers

    
    var media: Media?
    var content: NewPost?
    var uploadProgressPublishSubject: PublishSubject<UploadProgress>?
    
    private func createContentForUpload() {
        
    }
    
    private func createMediaUploadUrl() {
        
    }
    
    private func uploadMedia() {
        
    }
    
    private func uploadContent() {
        
    }
    
    private func publishContent() {
        
    }
    
    func upload(media: Media, content: NewPost) -> Observable<UploadProgress> {
        self.media = media
        self.content = content
        
        uploadProgressPublishSubject = PublishSubject<UploadProgress>()
        
        let endpointUrl = ""
        
        let mediaRequest = request(.get, endpointUrl)
            .flatMap { request -> Observable<(Data?, RxProgress)> in
                let dataPart = request.rx
                    .data()
                    .map { d -> Data? in d }
                    .startWith(nil as Data?)
                let progressPart = request.rx.progress()
                return Observable.combineLatest(dataPart, progressPart) { ($0, $1) }
            }
            .observeOn(MainScheduler.instance)
        
        return uploadProgressPublishSubject!
            .asObservable()
    }
    
    init(dependencies: Dependencies = .standard) {
        self.media = nil
        self.content = nil
        self.uploadProgressPublishSubject = nil
        
        self.baseUrl = dependencies.baseUrl
        self.schedulers = dependencies.schedulers
        self.uploadSession = Session.default
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
