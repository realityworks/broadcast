//
//  ProfileVersionTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 5/1/21.
//

import UIKit

class ProfileVersionTableViewCell: UITableViewCell {
    static let identifier: String = "ProfileVersionTableViewCell"
    static let cellHeight: CGFloat = 40
    
    let label = UILabel.lightGreySmallBody()
    
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
        contentView.addSubview(label)
        label.centerInSuperview()
        
        label.text = "\(LocalizedString.version) \(Configuration.versionString) (\(Configuration.buildString))"
    }
}

