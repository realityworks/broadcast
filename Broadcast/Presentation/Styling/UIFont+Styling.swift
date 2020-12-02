//
//  UIFont+Styling.swift
//  Broadcast
//
//  Created by Piotr Suwara on 19/11/20.
//

import UIKit

extension UIFont {
    
    /// Creates a font custom to the application style
    /// - Parameters:
    ///   - size: Font size in points
    ///   - weight: Standard weight for a font (regular, italic etc...)
    class func customFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    static var largeTitle: UIFont { .customFont(ofSize: 18, weight: .bold ) }
    static var title: UIFont { .customFont(ofSize: 15, weight: .regular ) }
    static var titleBold: UIFont { .customFont(ofSize: 15, weight: .bold ) }
    static var body: UIFont { .customFont(ofSize: 12, weight: .regular ) }
    static var bodyBold: UIFont { .customFont(ofSize: 12, weight: .bold ) }
}
