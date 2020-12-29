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
    }
    
    static let bodyBold = Style {
        $0.font = UIFont.bodyBold
    }
    
    static let bodyCenter = Style {
        $0.font = UIFont.body
        $0.color = UIColor.primaryBlack
        $0.alignment = .center
    }
    
    static let smallBodyGrey = Style {
        $0.font = UIFont.smallBody
        $0.color = UIColor.primaryLightGrey
    }
    
    static let smallBody = Style {
        $0.font = UIFont.smallBody
        $0.color = UIColor.secondaryBlack
    }
}
