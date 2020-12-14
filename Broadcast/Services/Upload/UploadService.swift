//
//  UploadService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

protocol UploadProgress {
    var progress: Float { get } // Progress indicator on how much of the upload is complete
}

protocol UploadService {
    func inject(apiService: APIService)
    func upload(media: Media, content: NewPost) -> Observable<UploadProgress>
}
