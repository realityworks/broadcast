//
//  ProfileSectionHeaderCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import UIKit


class ProfileSectionHeaderCell: UITableViewCell {
    let label = UILabel.bodyBold()

    static let cellHeight: CGFloat = 33
    static let identifier: String = "ProfileSectionHeaderCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Self.identifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        // This needs to be a solid colour since other rows can potentially scroll under it
        contentView.addSubview(label)
        label.edgesToSuperview(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        contentView.backgroundColor = .white
    }
}
