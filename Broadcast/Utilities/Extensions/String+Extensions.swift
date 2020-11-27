//
//  String+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/11/20.
//

import Foundation

extension String {
    init(_ localizedString: LocalizedString) {
        self = localizedString.localized
    }
}
