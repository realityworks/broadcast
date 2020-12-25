//
//  ErrorPopup.swift
//  Broadcast
//
//  Created by Piotr Suwara on 25/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class ErrorPopup : UIView {
    let button = UIButton.standard(withTitle: LocalizedString.tryAgain)
    let titleLabel = UILabel.largeTitle()
    let descriptionLabel = UILabel.body()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
