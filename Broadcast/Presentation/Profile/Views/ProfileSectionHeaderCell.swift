//
//  ProfileSectionHeaderCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import UIKit


class SettingsSectionHeaderCell: UITableViewCell {
    let label = UILabel.bodyBold(<#T##text: LocalizedString##LocalizedString#>)

    static let cellHeight: CGFloat = 33
    static let identifier: String = "SettingsSectionHeaderCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        styleView()
    }

    private func styleView() {
        // This needs to be a solid colour since other rows can potentially scroll under it
        backgroundColor = .clear
        label.textColor = .mist
        label.font = .sectionHeaderText
    }
}


