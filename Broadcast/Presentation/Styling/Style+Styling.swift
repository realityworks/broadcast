//
//  Style+Extension.swift
//  Broadcast
//
//  Created by Piotr Suwara on 2/12/20.
//

import UIKit
import SwiftRichString

extension Style {
    static let titleBold = Style {
        $0.font = UIFont.titleBold
        $0.alignment = .center
    }
    
    static let title = Style {
        $0.font = UIFont.title
        $0.alignment = .center
    }
}
