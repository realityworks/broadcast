//
//  PersistanceService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

protocol PersistanceService {
    func write<T>(value: T, forKey: String)
    func read<T>(key: String) -> T?
}

struct PersistenceKeys {
    static let tipsShown: String = "tipsShown"
}
