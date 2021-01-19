//
//  FileManager+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 19/1/21.
//

import Foundation


extension FileManager {
    func documentsDirectory() -> URL {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
