//
//  NewPostGuideViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftRichString
import AVFoundation

class NewPostGuideViewController: ViewController {
    // MARK: View Model
    private let viewModel = NewPostGuideViewModel()
    
    // MARK: UI Components
    let mainStackView = UIStackView()
    let tipTitleLabel = UILabel()
    
    let detailsStackView = UIStackView()
    let hotTipsTitleLabel = UILabel()
    let doNotShowAgainButton = UIButton()
    let tipsBackgroundView = UIView()
    let tipsList = UIStackView()
    let selectButton = UIButton.standard(withTitle: LocalizedString.select)
    
    // MARK: UIPickerController
    var picker = UIImagePickerController()
    
    struct TipData {
        let icon: UIImage?
        let text: NSAttributedString
    }
    
    let tipsListData: [TipData] = [
        TipData(icon: UIImage(systemName: "paintbrush"),
                text: "Upload or record in ".set(style: Style.title) +
                    "portrait".set(style: Style.titleBold)),
        TipData(icon: UIImage(systemName: "paintbrush"), text: "Keep it snappy".set(style: Style.title)),
        TipData(icon: UIImage(systemName: "paintbrush"), text: "Remember, good sound and lighting!".set(style: Style.title))
    ]
    
    // MARK: UI Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Post"
        
        picker.delegate = self
        picker.allowsEditing = false
        picker.videoQuality = .typeHigh
        picker.videoExportPreset = AVAssetExportPresetPassthrough

        // Do any additional setup after loading the view.
        configureViews()
        configureLayout()
        style()
        configureBindings()
    }
    
    // MARK: UI Configuration
    private func configureViews() {
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.spacing = 10
        
        detailsStackView.axis = .vertical
        detailsStackView.distribution = .equalSpacing
        detailsStackView.spacing = 10
    }
    
    private func configureLayout() {
        view.addSubview(mainStackView)
        mainStackView.centerInSuperview()
        mainStackView.leftToSuperview(offset: 20)
        mainStackView.rightToSuperview(offset: -20)
        
        mainStackView.addArrangedSubview(tipTitleLabel)
        
        detailsStackView.addSpace(10)
        // Setup tips layout with stack views
        tipsListData.forEach { tipData in
            let horizontalStackView = UIStackView()

            let imageView = UIImageView(image: tipData.icon)
            imageView.contentMode = .scaleAspectFit
            imageView.height(20)
            imageView.width(30)

            let label = UILabel()
            label.attributedText = tipData.text

            horizontalStackView.addArrangedSubview(imageView)
            horizontalStackView.addArrangedSubview(label)
            detailsStackView.addArrangedSubview(horizontalStackView)
        }
        detailsStackView.addSpace(10)

        mainStackView.addArrangedSubview(tipsBackgroundView)
        let selectButtonContainerView = UIView()
        selectButtonContainerView.addSubview(selectButton)

        mainStackView.addArrangedSubview(selectButtonContainerView)
        selectButton.width(150)
        selectButton.centerInSuperview()
        selectButtonContainerView.height(to: selectButton)
        
        tipsBackgroundView.addSubview(detailsStackView)
        detailsStackView.edgesToSuperview()
        tipsBackgroundView.height(to: detailsStackView)
    }
    
    private func style() {
        detailsStackView.backgroundColor = .clear
        tipsBackgroundView.layer.cornerRadius = 10
        tipsBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        tipTitleLabel.attributedText = LocalizedString.newPostTipsTitle.localized.set(style: Style.titleBold)
    }
    
    private func configureBindings() {
        selectButton.rx.tap
            .subscribe(onNext: { [weak self] _ in // TODO
                self?.showMediaOptionsMenu()
            })
            .disposed(by: disposeBag)
        
        viewModel.mediaSelected
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.push(with: .newPostDetail)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: UIImagePickerControllerDelegate
extension NewPostGuideViewController: UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate {
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            selected(imageUrl: imageUrl)
        } else if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            selected(videoUrl: videoUrl)
        }
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(
      _ picker: UIImagePickerController
    ) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: MediaPickerAdapter

extension NewPostGuideViewController : MediaPickerAdapter {
    func selected(imageUrl url: URL) {
        // Image Selected
        viewModel.mediaSelected(.image(url: url))
    }
    
    func selected(videoUrl url: URL) {
        // Video Selected
        viewModel.mediaSelected(.video(url: url))
    }
}

