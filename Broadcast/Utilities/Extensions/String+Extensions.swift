//
//  String+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/11/20.
//

import Foundation

extension String {
    static func localizedStringWithFormat(_ format: LocalizedString, _ arguments: CVarArg...) -> String {
        return localizedStringWithFormat(format.localized, arguments)
    }
    
    init(_ localizedString: LocalizedString) {
        self = localizedString.localized
    }
    
    static var empty: String {
        return ""
    }
}
