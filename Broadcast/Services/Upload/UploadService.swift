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

protocol UploadService {
    func inject(apiService: APIService)
    func upload(media: Media, content: PostContent) -> Observable<UploadProgress>
}
