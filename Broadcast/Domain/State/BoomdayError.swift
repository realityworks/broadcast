//
//  BoomdayError.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/11/20.
//

import Foundation

enum BoomdayError : Error {
    case unknown
    case unsupported // Currently not implemented
    case decoding(error: DecodingError)
    case apiNotFound
    case apiStatusCode(code: Int)
    case uploadFailed(UploadEvent)
}
