//
//  UploadService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

enum Media {
    case image(fileUrl: URL)
    case video(fileUrl: URL)
}

protocol UploadService {
    func upload(media: Media, content: NewPost)
}
