//
//  Float+Extension.swift
//  Broadcast
//
//  Created by Piotr Suwara on 7/12/20.
//

import Foundation

extension Float {
    func asCurrencyString(withCurrencyCode currencyCode: CurrencyCode) -> String {
        let currencyAmount = String(format: "%.2f", self)
        return "\(Locale.currencySymbol(from: currencyCode) ?? "") \(currencyAmount) \(currencyCode)"
    }
}
