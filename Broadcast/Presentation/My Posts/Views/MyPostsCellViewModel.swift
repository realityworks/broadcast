//
//  MyPostsCellViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit

struct MyPostsCellViewModel {
    let postId: PostID
    let title: String
    let caption: String
    let thumbnailUrl: URL?
    let media: Media?
    let isEncoding: Bool
    let dateCreated: String
    let commentCount: Int
    let lockerCount: Int
}
