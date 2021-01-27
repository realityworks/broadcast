//
//  URL+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/12/20.
//

import Foundation
import CoreServices

extension URL {
    func fileSize() -> Int64? {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: self.path) else {
            return nil
        }

        return attrs[.size] as? Int64
    }
    
    func copiedToLocal(filename: String) throws -> URL {
        let destinationUrl = FileManager.default.documentsDirectory().appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            try FileManager.default.removeItem(at: destinationUrl)
        }
        
        try FileManager.default.copyItem(at: self, to: destinationUrl)
        return destinationUrl
    }
    
    var mimeType: String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}
