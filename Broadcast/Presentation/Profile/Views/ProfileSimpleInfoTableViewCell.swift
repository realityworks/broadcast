//
//  ProfileSimpleInfoTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 14/1/21.
//

import UIKit

class ProfileSimpleInfoTableViewCell: UITableViewCell {
    let label = UILabel.lightGreySmallBody()

    static let cellHeight: CGFloat = 32
    static let identifier: String = "ProfileSimpleInfoTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Self.identifier)
        configureView()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        // This needs to be a solid colour since other rows can potentially scroll under it
        label.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    private func layoutViews() {
        contentView.addSubview(label)
        label.edgesToSuperview(excluding: [.leading])
        label.leftToSuperview(offset: 24)
    }
    
    func configure(withText text: LocalizedString) {
        label.text = text.localized
    }
}

