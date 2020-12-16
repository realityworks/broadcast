//
//  URL+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 16/12/20.
//

import Foundation

extension URL {
    func fileSize() -> Int64? {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: self.path) else {
            return nil
        }

        return attrs[.size] as? Int64
    }
}
