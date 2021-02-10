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
    
    func appendingQueryItem(_ queryItem: String, value: String?) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        
        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        // Append the new query item in the existing query items array
        queryItems.append(queryItem)
        
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        
        // Returns the url from new url components
        return urlComponents.url!
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
    
    func queryParametersRemoved() -> URL? {
        var urlComponents = URLComponents(string: absoluteString)
        urlComponents?.queryItems = []
        return urlComponents?.url
    }
}
