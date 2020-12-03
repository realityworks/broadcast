//
//  ProfileTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import UIKit

class ProfileTableViewCell : UITableViewCell {
    static let identifier = "ProfileTableViewCell"
    
    let titleLabel = UILabel()
    let icon = UIImageView()
        
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
    func configure(withTitle title: String,
                   icon: UIImage?,
                   titleColor: UIColor = .darkGray) {
        
    }
    
    private func configureView() {
        addSubview(titleLabel)
        addSubview(icon)
        titleLabel.leftToSuperview(offset: 10)
        titleLabel.rightToLeft(of: icon)
        titleLabel.topToSuperview()
        titleLabel.bottomToSuperview()
        
        icon.rightToSuperview(offset: -10)
        icon.centerYToSuperview()
        icon.height(20)
        icon.aspectRatio(1)
        icon.contentMode = .scaleAspectFit
    }
    
    private func styleView() {
        
    }
}

