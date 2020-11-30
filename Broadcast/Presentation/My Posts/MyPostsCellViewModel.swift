//
//  MyPostsCellViewModel.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit

struct MyPostsCellViewModel {
    let title: String
    let thumbnailURL: URL?
    let isEncoding: Bool
    let dateCreated: String
    let commentCount: Int
    let lockerCount: Int
}
