//
//  Media.swift
//  Broadcast
//
//  Created by Piotr Suwara on 2/12/20.
//

import Foundation

typealias MediaID = String

/// Enum definition of a type of media with an associated access URL
enum Media : Equatable {
    case video(url: URL)
    case image(url: URL)
}
