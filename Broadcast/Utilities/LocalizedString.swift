//
//  LocalizedString.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/11/20.
//

import Foundation

enum LocalizedString : String {

    case loginButton
    case usernamePlaceholder
    case passwordPlaceholder
    case myPostsHeading
    case newPostTipsTitle
    case select
    
    var localized: String {
        return Bundle.main.localizedString(forKey: self.rawValue, value: nil, table: nil)
    }
}
