//
//  UploadService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

enum UploadableContent {
    case image(fileUrl: URL)
    case video(fileUrl: URL)
}

protocol UploadService {
    var stateController: StateController { get }
    func upload(content: UploadableContent)
}
