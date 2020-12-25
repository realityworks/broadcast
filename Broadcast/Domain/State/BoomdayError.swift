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
            return "\(LocalizedString.apiStatusCodeError.localized) : \(errorCode)"
        default:
            return LocalizedString.invalidError.localized
        }
    }
}
