//
//  StandardPersistenceService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/1/21.
//

import Foundation

class StandardPersistenceService : PersistanceService {
    func write<T>(value: T, forKey key: String) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    func read<T>(key: String) -> T? {
        return UserDefaults.standard.value(forKey: key) as? T
    }
}

// MARK: Instance methods

extension StandardPersistenceService {
    static let standard: StandardPersistenceService = StandardPersistenceService()
}
