//
//  ProfileTrailerTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 4/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileTrailerTableViewCell: UITableViewCell {
    static let identifier: String = "ProfileTrailerTableViewCell"
    static let cellHeight: CGFloat = 320
    
    private let selectMediaContainerView = UIView()
    private let selectMediaView = SelectMediaView()
    private let selectMediaInfoStackView = UIStackView()
    private let runTimeLabel = UILabel()
    private let selectedMediaTitleLabel = UILabel.largeTitle(.noMedia, textColor: .primaryLightGrey)
    
    private let removeButton = UIButton.textDestructive(withTitle: LocalizedString.remove)
    private let uploadButton = UIButton.standard(withTitle: LocalizedString.uploadTrailer)
    
    let progressView = ProgressView()
    
    let disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    private func configureViews() {
        selectMediaInfoStackView.axis = .vertical
        selectMediaInfoStackView.alignment = .leading
        selectMediaInfoStackView.spacing = 4
        
        removeButton.contentHorizontalAlignment = .leading
        
        contentView.addSubview(selectMediaContainerView)
        selectMediaContainerView.topToSuperview(offset:24)
        selectMediaContainerView.height(200)
        selectMediaContainerView.leftToSuperview(offset: 24)
        selectMediaContainerView.rightToSuperview()
        
        selectMediaContainerView.addSubview(selectMediaView)
        selectMediaView.leftToSuperview()
        selectMediaView.topToSuperview()
        selectMediaView.width(200)
        selectMediaView.height(200)
        
        selectMediaContainerView.addSubview(selectMediaInfoStackView)
        selectMediaInfoStackView.addArrangedSubview(selectedMediaTitleLabel)
        selectMediaInfoStackView.addArrangedSubview(runTimeLabel)
        
        runTimeLabel.height(18)
        
        selectMediaInfoStackView.leftToRight(of: selectMediaView, offset: 16)
        selectMediaInfoStackView.top(to: selectMediaView)
        selectMediaInfoStackView.width(100)

        contentView.addSubview(uploadButton)
        selectMediaContainerView.bottomToTop(of: uploadButton, offset: 24)
        
        uploadButton.leftToSuperview(offset: 24)
        uploadButton.rightToSuperview(offset: -24)
        uploadButton.bottomToSuperview(offset: -24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
