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
    
    var localized: String {
        return Bundle.main.localizedString(forKey: self.rawValue, value: nil, table: nil)
    }
}
