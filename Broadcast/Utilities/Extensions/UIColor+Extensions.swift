//
//  UIColor+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 22/12/20.
//

import UIKit

extension UIColor {
    /// Initialize a UIColor from different styles of Hex String representations.
    /// The string can have an option # symbol prefix or simply hex symbols.
    /// Support 3 / 6 and 8 Hex character colour representations.
    /// - Parameter hex: The hexadecimal representation in string form.
    public convenience init(hex: String) {
        let hexStringTrimmed = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var hexInt: UInt64 = 0
        Scanner(string: hexStringTrimmed).scanHexInt64(&hexInt)
        
        let a, r, g, b: UInt64
        switch hexStringTrimmed.count {
        case 3: // RGB (12-Bit)
            (a, r, g, b) = (255, (hexInt >> 8) * 17, (hexInt >> 4 & 0xF) * 17, (hexInt & 0xF) * 17)
        case 6: // ARGB (24-Bit)
            (a, r, g, b) = (255, hexInt >> 16, hexInt >> 8 & 0xFF, hexInt & 0xFF)
        case 8: // ARGB (32-Bit)
            (a, r, g, b) = (hexInt >> 24, hexInt >> 16 & 0xFF, hexInt >> 8 & 0xFF, hexInt & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
                
        self.init(
            displayP3Red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255)
    }
}
