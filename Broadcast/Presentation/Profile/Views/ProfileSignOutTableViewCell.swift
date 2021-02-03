//
//  ProfileSignOutTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 5/1/21.
//

import UIKit
import RxSwift

class ProfileSignOutTableViewCell: UITableViewCell {
    static let identifier: String = "ProfileSignOutTableViewCell"
    static let cellHeight: CGFloat = 80
    
    let label = UILabel.body(LocalizedString.logout, textColor: .primaryGrey)
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(label)
        
        contentView.addTopSeparator()
        contentView.addBottomSeparator()
        
        label.leftToSuperview(offset: 24)
        label.centerYToSuperview()
        
        selectionStyle = .none
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        label.isHighlighted = highlighted
    }
}

