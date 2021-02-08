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
    }
    
    static let titleCenter = Style {
        $0.font = UIFont.title
        $0.alignment = .center
    }
    
    static let title = Style {
        $0.font = UIFont.title
    }
    
    static let body = Style {
        $0.font = UIFont.body
        $0.color = UIColor.secondaryBlack
    }
    
    static let lightGrey = Style {
        $0.color = UIColor.primaryLightGrey
    }
    
    static let bodyBold = Style {
        $0.font = UIFont.bodyBold
    }
    
    static let bodyCenter = Style {
        $0.font = UIFont.body
        $0.color = UIColor.primaryBlack
        $0.alignment = .center
    }
    
    static let smallBody = Style {
        $0.font = UIFont.smallBody
        $0.color = UIColor.secondaryBlack
    }
    
    static let smallBodyBold = Style {
        $0.font = UIFont.smallBodyBold
        $0.color = UIColor.secondaryBlack
    }
    
    static func link(_ url: URL) -> Style {
        return Style {
            $0.font = UIFont.body
            $0.underline = (.single, UIColor.primaryGrey)
            $0.linkURL = url
            $0.alignment = .center
        }
    }
}
