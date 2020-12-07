//
//  Locale+Extension.swift
//  Broadcast
//
//  Created by Piotr Suwara on 7/12/20.
//

import Foundation

extension Locale {
    static func locale(from currencyIdentifier: String) -> Locale? {
        let allLocales = Locale.availableIdentifiers.map({ Locale.init(identifier: $0) })
        return allLocales.filter({ $0.currencyCode == currencyIdentifier }).first
    }
    
    static func currencySymbol(for currencyIdentifier: String) -> String? {
        guard let locale = Self.locale(from: currencyIdentifier) else { return nil }
        return locale.currencySymbol
    }
}
