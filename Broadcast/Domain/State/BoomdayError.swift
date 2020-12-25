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
            return "\(LocalizedString.unsupportedError.localized) : \(decodingError)"
        case .apiNotFound:
            return "This call does not exist in the API"
        case .apiStatusCode(let errorCode):
            return "The Web API returned an undefined error code : \(errorCode)"
        default:
            return "Invalid Error"
        }
    }
}
