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
    
    func upload(media: Media, content: NewPost) -> Observable<(Data?, RxProgress)>
}
