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
    
    let button = UIButton.textDestructive(withTitle: LocalizedString.logout)
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(button)
        button.centerInSuperview()
    }    
}

