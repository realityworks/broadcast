//
//  MediaUrl.swift
//  Broadcast
//
//  Created by Piotr Suwara on 2/12/20.
//

import Foundation

enum MediaUrl : Equatable {
    case video(url: URL)
    case image(url: URL)
}
