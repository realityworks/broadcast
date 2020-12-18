//
//  LoadMyPostsResponse.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import Foundation

struct LoadMyPostsResponse : Decodable {
    let posts: [Post]
}
