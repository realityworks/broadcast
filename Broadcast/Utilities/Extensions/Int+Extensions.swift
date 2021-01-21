//
//  Int.swift
//  Broadcast
//
//  Created by Piotr Suwara on 31/12/20.
//

import Foundation

extension Int {
    /// Convert an int to a currency string with a specified currency code. The currency decimal count is defined by
    /// a specified number of digits. So an int value of 1200 with a `decimals` value of 2, the resulting
    /// value will be 12.00
    /// - Parameters:
    ///   - currencyCode: The currency code that provides a
    ///   - decimals: Decimal places to use in the string
    /// - Returns: A string with the currency symbol at the front, the value and the code at the end.
    ///            eg. $10.00 USD
    func asCurrencyString(withCurrencyCode currencyCode: CurrencyCode,
                          decimals: Int = 2) -> String {
        
        let multiple = pow(10.0, Float(decimals))
        let total: Float = (Float(self) / multiple)
        let currencyAmount = String(format: "%.2f", total)
        let uppercasedCurrencyCode = currencyCode.rawValue.uppercased()
        return "\(Locale.currencySymbol(from: currencyCode) ?? "") \(currencyAmount) \(uppercasedCurrencyCode)"
    }
}
