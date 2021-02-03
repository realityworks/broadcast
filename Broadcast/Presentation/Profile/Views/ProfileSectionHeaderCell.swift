//
//  ProfileSectionHeaderCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import UIKit


class ProfileSectionHeaderCell: UITableViewCell {
    let verticalStackView = UIStackView()
    let labelContainer = UIView()
    let label = UILabel.lightGreySmallBody()

    static let cellHeight: CGFloat = 82
    static let identifier: String = "ProfileSectionHeaderCell"

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
        contentView.addSubview(verticalStackView)
        labelContainer.addSubview(label)
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 0
        
        labelContainer.backgroundColor = .white
        
        contentView.backgroundColor = .clear
    }
    
    private func layoutViews() {
        verticalStackView.addSpace(32, color: .clear)
        verticalStackView.addSeparator()
        verticalStackView.addArrangedSubview(labelContainer)
        verticalStackView.addSeparator()
        
        labelContainer.height(48)
        labelContainer.leftToSuperview()
        labelContainer.rightToSuperview()
        label.edgesToSuperview(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        verticalStackView.edgesToSuperview(excluding: .bottom)
    }
}
