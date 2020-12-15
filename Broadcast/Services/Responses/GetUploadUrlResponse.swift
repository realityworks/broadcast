//
//  GetUploadUrlResponse.swift
//  Broadcast
//
//  Created by Piotr Suwara on 14/12/20.
//

import Foundation

struct GetUploadUrlResponse : Decodable {
    let uploadUrl: String
    let mediaId: String
}
