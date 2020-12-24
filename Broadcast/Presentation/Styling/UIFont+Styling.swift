//
//  UIFont+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 19/11/20.
//

import UIKit

extension UIFont {
    
    enum InterVFontWeight: String {
        case italic = "InterV_Italic"
        case regular = "InterV"
        case thin = "InterV_Thin"
        case thinItalic = "InterV_Thin-Italic"
        case extraLight = "InterV_Extra-Light"
        case extraLightItalic = "InterV_Extra-Light-Italic"
        case light = "InterV_Light"
        case lightItalic = "InterV_Light-Italic"
        case medium = "InterV_Medium"
        case mediumItalic = "InterV_Medium-Italic"
        case semiBold = "InterV_Semi-Bold"
        case semiBoldItalic = "InterV_Semi-Bold-Italic"
        case bold = "InterV_Bold"
        case boldItalic = "InterV_Bold-Italic"
        case extraBold = "InterV_Extra-Bold"
        case extraBoldItalic = "InterV_Extra-Bold-Italic"
        case black = "InterV_Black"
        case blackItalic = "InterV_Black-Italic"
    }
    
    enum InterFontWeight {
        
    }
    
    /// Creates a font custom to the application style of the Inter font family
    /// - Parameters:
    ///   - size: Font size in points
    ///   - weight: Standard weight for a font (regular, italic etc...)
    class func interFont(ofSize size: CGFloat, weight: InterFontWeight) -> UIFont {
        return UIFont(name: weight, size: size)
    }
    
    
    
    static var largeTitle: UIFont { .interFont(ofSize: 18, weight: .bold ) }
    static var title: UIFont { .interFont(ofSize: 15, weight: .regular ) }
    static var titleBold: UIFont { .interFont(ofSize: 15, weight: .bold ) }
    static var body: UIFont { .interFont(ofSize: 12, weight: .regular ) }
    static var bodyBold: UIFont { .interFont(ofSize: 12, weight: .bold ) }
}
