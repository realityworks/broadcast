//
//  LocalizedString.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/11/20.
//

import Foundation

enum LocalizedString : String {
    case none
    case loginButton
    case usernamePlaceholder
    case passwordPlaceholder
    case myPostsHeading
    case newPostTipsTitle
    case select
    case profileInformation
    case subscription
    case frequentlyAskedQuestions
    case privacyPolicy
    case termsAndConditions
    case shareProfile
    case logout
    case accountSettings
    case support
    case legal
    case displayName
    case displayBio
    case trailerVideo
    case change
    case subscribers
    case disabled
    case enabled
    case name
    case id
    case pricing
    case payments
    case payouts
    case totalBalance
    case lifetimeTotalVolume
    case videoToUpload
    case postTitle
    case postDescription
    case captionTitle
    case captionDescription
    case publish
    case notABroadcaster
    case learnMore
    case forgotPassword
    case welcome
    case tryAgain
    case error
    case unknownError
    case unsupportedError
    case decodingError
    case apiNotFoundError
    case apiStatusCodeError
    case invalidError
    case addMedia
    case newPost
    case tips
    case noMedia
    
    var localized: String {
        return Bundle.main.localizedString(forKey: self.rawValue, value: nil, table: nil)
    }
}
