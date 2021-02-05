//
//  String+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/11/20.
//

import Foundation

extension String {
    static func localizedStringWithFormat(_ format: LocalizedString, _ arguments: CVarArg...) -> String {
        let formatString = format.localized
        let localizedWithFormat = String(format: formatString, arguments)
        return localizedWithFormat
    }
    
    init(_ localizedString: LocalizedString) {
        self = localizedString.localized
    }
    
    static var empty: String {
        return ""
    }
}
