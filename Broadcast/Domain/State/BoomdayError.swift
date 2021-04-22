//
//  BoomdayError.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/11/20.
//

import Foundation

enum BoomdayError : Error {
    case unknown
    case unsupported
    case refused
    case decoding(error: DecodingError)
    case apiNotFound
    case authenticationFailed
    case apiStatusCode(code: Int)
    case uploadFailed(UploadEvent)
    case publishFailed
    case internalMemoryError(text: String)
    case noMembershipError
    case paymentFailedError
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return LocalizedString.unknownError.localized
        case .unsupported:
            return LocalizedString.unsupportedError.localized
        case .refused:
            return LocalizedString.refusedError.localized
        case .decoding(let decodingError):
            return "\(LocalizedString.decodingError.localized) : \(decodingError)"
        case .apiNotFound:
            return LocalizedString.apiNotFoundError.localized
        case .authenticationFailed:
            return LocalizedString.authenticationFailedError.localized
        case .apiStatusCode(let errorCode):
            return "\(LocalizedString.apiStatusCodeError.localized) : \(errorCode)"
        case .publishFailed:
            return LocalizedString.publishError.localized
        case .uploadFailed(let event):
            return "\(LocalizedString.uploadFailed.localized) : \(event)"
        case .internalMemoryError(let text):
            return "\(LocalizedString.internalMemoryError.localized) : \(text)"
        case .noMembershipError:
            return LocalizedString.noMembershipError.localized
        case .paymentFailedError:
            return LocalizedString.paymentFailedError.localized
        }
    }
    
    static func errorString(from error: Error) -> String {
        if let boomDayError = error as? BoomdayError {
            return boomDayError.localizedDescription
        }
        
        return error.localizedDescription
    }
}
