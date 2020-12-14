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

class StandardUploadService : UploadService {
    
    var media: Media?
    var content: NewPost?
    
    private func createContentForUpload() {
        
    }
    
    private func createMediaUploadUrl(){
        
    }
    
    func uploadMedia()
    func uploadContent()
    func publishContent()
    
    func upload(media: Media, content: NewPost) -> Observable<(Data?, RxProgress)> {
        // TODO
        let endpointUrl = ""
        
        return request(.get, endpointUrl)
            .flatMap { request -> Observable<(Data?, RxProgress)> in
                let dataPart = request.rx
                    .data()
                    .map { d -> Data? in d }
                    .startWith(nil as Data?)
                let progressPart = request.rx.progress()
                return Observable.combineLatest(dataPart, progressPart) { ($0, $1) }
            }
            .observeOn(MainScheduler.instance)
    }
    
    init(dependencies: Dependencies = .standard) {
        
    }
}

// MARK: Dependencies

extension StandardUploadService {
    struct Dependencies {
        static let standard = Dependencies()
    }
}
