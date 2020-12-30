//
//  UIFont+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 19/11/20.
//

import UIKit
protocol FontWeight {
    func name() -> String
}

extension FontWeight where Self : RawRepresentable, Self.RawValue == String {
    func name() -> String {
        return self.rawValue
    }
}

extension UIFont {
    enum InterVFontWeight: String, FontWeight {
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
    
    enum InterFontWeight: String, FontWeight {
        case regular = "Inter-Regular"
        case italic = "Inter-Italic"
        case thin = "Inter-Thin"
        case thinItalic = "Inter-ThinItalic"
        case extraLight = "Inter-ExtraLight"
        case extraLightItalic = "Inter-ExtraLightItalic"
        case light = "Inter-Light"
        case lightItalic = "Inter-LightItalic"
        case medium = "Inter-Medium"
        case mediumItalic = "Inter-MediumItalic"
        case semiBold = "Inter-SemiBold"
        case semiBoldItalic = "Inter-SemiBoldItalic"
        case bold = "Inter-Bold"
        case boldItalic = "Inter-BoldItalic"
        case extraBold = "Inter-ExtraBold"
        case extraBoldItalic = "Inter-ExtraBoldItalic"
        case black = "Inter-Black"
        case blackItalic = "Inter-BlackItalic"
    }
    
    /// Creates a font custom to the application style of the Inter font family
    /// - Parameters:
    ///   - size: Font size in points
    ///   - weight: Standard weight for a font (regular, italic etc...)
    class func customFont(ofSize size: CGFloat, weight: FontWeight) -> UIFont {
        guard let font = UIFont(name: weight.name(), size: size) else {
            Logger.log(level: .warning, topic: .debug, message: "Font : \(weight.name()) not found")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    static var extraLargeTitle: UIFont { .customFont(ofSize: 22, weight: InterFontWeight.bold ) }
    static var largeTitle: UIFont { .customFont(ofSize: 18, weight: InterFontWeight.bold ) }
    static var title: UIFont { .customFont(ofSize: 15, weight: InterFontWeight.regular ) }
    static var titleBold: UIFont { .customFont(ofSize: 15, weight: InterFontWeight.bold ) }
    static var largeBodyBold: UIFont { .customFont(ofSize: 16, weight: InterFontWeight.bold ) }
    static var smallBody: UIFont { .customFont(ofSize: 12, weight: InterFontWeight.medium ) }
    static var tinyBody: UIFont { .customFont(ofSize: 11, weight: InterFontWeight.medium ) }
    static var smallBodyBold: UIFont { .customFont(ofSize: 12, weight: InterFontWeight.bold ) }
    static var body: UIFont { .customFont(ofSize: 14, weight: InterFontWeight.regular ) }
    static var bodyBold: UIFont { .customFont(ofSize: 14, weight: InterFontWeight.bold ) }
    
    static var myPostTableTitle: UIFont { .customFont(ofSize: 24, weight: UIFont.InterFontWeight.medium ) }
    static var postCaptionTitle: UIFont { .customFont(ofSize: 20, weight: InterFontWeight.bold ) }
}
