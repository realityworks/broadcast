//
//  Dictionary+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 9/12/20.
//

import Foundation

extension Dictionary where Key : StringProtocol, Value : StringProtocol {
    var queryString: String {
        self.map { "\($0)=\($1)" }.joined(separator: "&")
    }
}
