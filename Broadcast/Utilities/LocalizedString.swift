//
//  LocalizedString.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/11/20.
//

import Foundation

enum LocalizedString : String {
    case none
    case nonExistant
    case loginButton
    case usernamePlaceholder
    case passwordPlaceholder
    case myPostsHeading
    case profileDetailHeading
    case profileStripeAccountHeading
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
    case submitPost
    case notABroadcaster
    case learnMore
    case forgotPassword
    case welcome
    case tryAgain
    case addMedia
    case newPost
    case tips
    case noMedia
    case duration
    case video
    case image
    case remove
    case uploadCompleted
    case uploadFailed
    case uploading
    case hotTips
    case greatContent
    case tip1Title
    case tip1SubTitle
    case tip2Title
    case tip2SubTitle
    case tip3Title
    case tip3SubTitle
    case tip4Title
    case tip4SubTitle
    case tip5Title
    case tip5SubTitle
    case tip6Title
    case tip6SubTitle
    case close
    case locker
    case comments
    case yes
    case no
    case and
    case cancelChanges
    case cancelChangesDescription
    case post
    case myProfile
    case version
    case deletePost
    case email
    case userHandle
    case uploadTrailer
    case emailUserLockedInfo
    case stripeAccountLockedInfo
    case processing
    case saving
    case usingAppAccept
    case createdAgo
    case acceptTerms
    case accept
    case decline
    
    // MARK: Error Strings
    case error
    case unknownError
    case unsupportedError
    case refusedError
    case decodingError
    case apiNotFoundError
    case authenticationFailedError
    case apiStatusCodeError
    case invalidError
    case publishError
    case uploadEventError
    case noPosts
    case internalMemoryError
    
    var localized: String {
        return Bundle.main.localizedString(forKey: self.rawValue, value: nil, table: nil)
    }
}
