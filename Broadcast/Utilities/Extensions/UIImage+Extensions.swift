//
//  UIImage+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 25/11/20.
//

import UIKit

extension UIImage {
    ///   Returns an optional image using the specified color
    ///     - parameter color: The color of the image.
    ///     - returns: An optional image based on `color`.
    public convenience init?(color: UIColor) {
        let size = CGSize(width: 1, height: 1)
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        color.setFill()
        UIRectFill(rect)

        defer { UIGraphicsEndImageContext() }

        guard let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }

        self.init(cgImage: image)
    }
}
