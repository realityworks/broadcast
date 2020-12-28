//
//  UIImage+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 25/11/20.
//

import UIKit
import AVFoundation

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

        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }

        self.init(cgImage: cgImage)
    }
    
    public convenience init?(asThumbnailFromUrl url: URL) {
        do
        {
            let asset = AVURLAsset(url: url)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at:CMTimeMake(value: Int64(0), timescale: Int32(1)),actualTime: nil)
            self.init(cgImage: cgImage)
        }
        catch let error as NSError
        {
            Logger.log(level: .warning, topic: .other, message: "Error generating thumbnail: \(error)")
            return nil
        }
    }
}
