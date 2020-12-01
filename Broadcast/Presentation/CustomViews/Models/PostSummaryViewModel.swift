//
//  PostSummaryViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 30/11/20.
//

import Foundation

struct PostSummaryViewModel {
    let title: String
    let thumbnailURL: URL?
    let videoURL: URL?
    let commentCount: Int
    let lockerCount: Int
    let dateCreated: String
    let isEncoding: Bool
    let showVideoPlayer: Bool
}
