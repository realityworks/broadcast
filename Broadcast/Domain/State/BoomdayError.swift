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
    case publishFailed
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return LocalizedString.unknownError.localized
        case .unsupported:
            return LocalizedString.unsupportedError.localized
        case .decoding(let decodingError):
            return "\(LocalizedString.decodingError.localized) : \(decodingError)"
        case .apiNotFound:
            return LocalizedString.apiNotFoundError.localized
        case .apiStatusCode(let errorCode):
            return "Failed with error : \(errorCode)"
        case .publishFailed:
            return LocalizedString.publishError.localized
        case .uploadFailed(let event):
            return "\(LocalizedString.uploadFailed.localized) : \(event)"
        }
    }
}
