//
//  PersistanceService.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import Foundation

protocol PersistanceService {
    func write<T, U>(value: T, forKey: U)
    func read<T, U>(key: U) -> T
}
