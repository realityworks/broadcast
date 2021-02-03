//
//  PostSummaryViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 30/11/20.
//

import Foundation

struct PostSummaryViewModel {
    let title: String
    let caption: String
    let thumbnailUrl: URL?
    let media: Media
    let commentCount: Int
    let lockerCount: Int
    let dateCreated: String
    let isEncoding: Bool
    let showVideoPlayer: Bool
}
