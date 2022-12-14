//
//  AccountInfoTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 7/12/20.
//

import UIKit
import SwiftRichString

class AccountInfoTableViewCell : UITableViewCell {
    static let identifier = "AccountInfoTableViewCell"
    static let cellHeight: CGFloat = 50
    
    let titleLabel = UILabel()
        
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        styleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuration and Styling
    func configure(withTitle titleText: String) {
        titleLabel.attributedText = titleText.set(style: Style.title)
    }
    
    private func configureView() {
        contentView.addSubview(titleLabel)
        titleLabel.edgesToSuperview(excluding: [.leading, .bottom])
        titleLabel.leadingToSuperview(offset: 20)
        titleLabel.height(40)
    }
    
    private func styleView() {
        
    }
}
