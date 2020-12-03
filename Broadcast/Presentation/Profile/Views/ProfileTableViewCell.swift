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
    func configureView() {
    }
    
    func styleView() {
    }
}

