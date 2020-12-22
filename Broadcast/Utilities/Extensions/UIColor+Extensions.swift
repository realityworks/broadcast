//
//  UIColor+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 22/12/20.
//

import Foundation
import UIKit

//#FD0A4C

extension UIColor {
    convenience init(hex: String) {
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
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255)
    }
}
