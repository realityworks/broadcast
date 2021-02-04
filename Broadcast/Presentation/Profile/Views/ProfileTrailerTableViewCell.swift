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
    static let failedUploadCellHeight: CGFloat = 370
    
    let selectMediaContainerView = UIView()
    let selectMediaInfoStackView = UIStackView()
    let runTimeLabel = UILabel()
    let selectedMediaTitleLabel = UILabel.largeTitle(.noMedia, textColor: .secondaryBlack)
    
    let selectMediaView = SelectMediaView()
    let changeButton = UIButton.textDestructive(withTitle: LocalizedString.change)
    
    let blurEffect = UIBlurEffect(style: .light)
    let blurredEffectView: UIVisualEffectView!
    let thumbnailImageView = UIImageView()
    let processingView = ProcessingView()
    
    let uploadContainerStackView = UIStackView()
    
    let failedContainerView = UIView()
    let failedStackView = UIStackView()
    let failedIconView = UIImageView(image: UIImage.iconSlash?.withTintColor(.primaryRed))
    let failedLabel = UILabel.bodyMedium(.uploadFailed,
                                         textColor: .secondaryBlack)
    
    let uploadButton = UIButton.standard(withTitle: LocalizedString.uploadTrailer)
    
    
    let progressView = ProgressView()
    
    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        
        self.blurredEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
        layoutViews()
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    private func configureViews() {
        selectMediaInfoStackView.axis = .vertical
        selectMediaInfoStackView.alignment = .leading
        selectMediaInfoStackView.spacing = 4
        
        uploadContainerStackView.axis = .vertical
        uploadContainerStackView.alignment = .center
        uploadContainerStackView.spacing = 2
        uploadContainerStackView.distribution = .fill
        
        failedStackView.axis = .vertical
        failedStackView.alignment = .center
        failedStackView.spacing = 2
        failedStackView.distribution = .fillProportionally
        
        changeButton.contentHorizontalAlignment = .leading
        
        uploadButton.isEnabled = false
        
        uploadButton.setImage(UIImage.iconRadio?.withTintColor(.buttonTitle), for: .normal)
        uploadButton.setImage(UIImage.iconRadio?.withTintColor(.disabledButtonTitle), for: .disabled)
                
        uploadButton.imageEdgeInsets = .right(10)
        
        failedIconView.contentMode = .scaleAspectFit
        
        thumbnailImageView.roundedCorners()
        blurredEffectView.roundedCorners()        
        processingView.animating = true
    }
    
    private func layoutViews() {
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
        
        /// Processing with thumbnail view (Order important)
        #warning("Refactor this in future to make a universal image with thumbnail view and processing view")
        selectMediaContainerView.addSubview(thumbnailImageView)
        selectMediaContainerView.addSubview(blurredEffectView)
        selectMediaContainerView.addSubview(processingView)
        
        blurredEffectView.edges(to: selectMediaView)
        thumbnailImageView.edges(to: selectMediaView)
        processingView.edges(to: selectMediaView)
        
        selectMediaContainerView.addSubview(selectMediaInfoStackView)
        selectMediaInfoStackView.addArrangedSubview(selectedMediaTitleLabel)
        selectMediaInfoStackView.addArrangedSubview(runTimeLabel)
        selectMediaInfoStackView.addArrangedSubview(changeButton)
        
        runTimeLabel.height(18)
        
        selectMediaInfoStackView.leftToRight(of: selectMediaView, offset: 16)
        selectMediaInfoStackView.top(to: selectMediaView, offset: 64)
        selectMediaInfoStackView.width(100)
        
        contentView.addSubview(uploadContainerStackView)
        uploadContainerStackView.addArrangedSubview(failedContainerView)
        uploadContainerStackView.addArrangedSubview(uploadButton)
        
        uploadContainerStackView.leftToSuperview(offset: 24)
        uploadContainerStackView.rightToSuperview(offset: -24)
        uploadContainerStackView.bottomToSuperview(offset: -24)
        
        uploadButton.widthToSuperview()
        
        failedContainerView.addSubview(failedStackView)
        failedStackView.edgesToSuperview()
        
        failedContainerView.widthToSuperview()
        failedContainerView.height(50)
        
        failedStackView.addArrangedSubview(failedIconView)
        failedStackView.addArrangedSubview(failedLabel)
        failedStackView.addSpace(4)
        
        contentView.addSubview(progressView)
        progressView.leftToSuperview(offset: 24)
        progressView.rightToSuperview(offset: -24)
        progressView.centerY(to: uploadContainerStackView, offset: -24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base : ProfileTrailerTableViewCell {
    var failed: Binder<Bool> {
        return Binder(base) { target, failed in
            let title = failed ?
                LocalizedString.tryAgain.localized :
                LocalizedString.uploadTrailer.localized
            
            target.uploadButton.setTitle(title, for: .normal)
            
            let image = failed ?
                UIImage.iconReload?.withTintColor(.white) :
                UIImage.iconRadio?.withTintColor(.white)
            
            target.uploadButton.setImage(image, for: .normal)
            target.failedContainerView.isHidden = !failed
        }
    }
    
    var trailerVideoProcessed: Binder<Bool> {
        return Binder(base) { target, trailerVideoProcessed in
            target.thumbnailImageView.isHidden = trailerVideoProcessed
            target.blurredEffectView.isHidden = trailerVideoProcessed
            target.processingView.isHidden = trailerVideoProcessed
            target.processingView.animating = !trailerVideoProcessed
        }
    }
}
