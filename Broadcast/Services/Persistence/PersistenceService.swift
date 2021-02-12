//
//  PersistenceService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

protocol PersistenceService {
    func write<T>(value: T, forKey: String)
    func read<T>(key: String) -> T?
    func remove(key: String)
}

struct PersistenceKeys {
    static let profileImage = "profile-image"
    static let tipsShown = "tipsShown"
    static let termsAccepted = "termsAccepted"
}
