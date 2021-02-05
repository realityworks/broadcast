//
//  String+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/11/20.
//

import Foundation

extension String {
    static func localizedWithFormat(_ localizedFormatString: LocalizedString,
                                    _ arguments: CVarArg...) -> String {
        return withVaList(arguments) { vaListPointer -> NSString in
            return NSString(format: localizedFormatString.localized,
                            arguments: vaListPointer)
        } as String
    }
    
    init(_ localizedString: LocalizedString) {
        self = localizedString.localized
    }
    
    static var empty: String {
        return ""
    }
}
