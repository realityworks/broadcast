//
//  Locale+Extension.swift
//  Broadcast
//
//  Created by Piotr Suwara on 7/12/20.
//

import Foundation

extension Locale {
    static func locale(from currencyCode: CurrencyCode) -> Locale? {
        let allLocales = Locale.availableIdentifiers.map({ Locale.init(identifier: $0) })
        return allLocales.filter({
                $0.currencyCode == currencyCode.rawValue.uppercased()
            }).first
    }
    
    static func currencySymbol(from currencyCode: CurrencyCode) -> String? {
        guard let locale = Self.locale(from: currencyCode) else { return nil }
        return locale.currencySymbol
    }
}
