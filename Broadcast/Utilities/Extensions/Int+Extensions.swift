//
//  Int.swift
//  Broadcast
//
//  Created by Piotr Suwara on 31/12/20.
//

import Foundation

extension Int {
    func asCurrencyString(withCurrencyCode currencyCode: CurrencyCode) -> String {
        let currencyAmount = String(format: "%d", self)
        return "\(Locale.currencySymbol(from: currencyCode) ?? "") \(currencyAmount) \(currencyCode)"
    }
}
