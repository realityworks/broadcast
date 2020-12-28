//
//  NewPostCreateViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 8/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import TinyConstraints

class NewPostCreateViewController : ViewController, KeyboardEventsAdapter {
    var dismissKeyboardGestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer()
    
    private let viewModel = NewPostCreateViewModel()
    
    // MARK: UI Components
    private let scrollView = UIScrollView()

    private let selectMediaView = SelectMediaView()
    
    private let selectMediaInfoStackView = UIStackView()
    private let runTimeLabel = UILabel()
    private let selectedMediaTitleLabel = UILabel.largeTitle(.noMedia, textColor: .lightGrey)
    private let tipsButton = UIButton.smallText(withTitle: LocalizedString.tips)
    
    private let editPostView = EditPostView()
    private let progressView = UIProgressView()
    internal var picker = UIImagePickerController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = LocalizedString.newPost.localized

        // Do any additional setup after loading the view.
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    private func configureViews() {
        view.addGestureRecognizer(dismissKeyboardGestureRecognizer)
        dismissKeyboardGestureRecognizer.delaysTouchesEnded = false
        dismissKeyboardGestureRecognizer.addTarget(self, action: #selector(dismissKeyboard))
        
        tipsButton.setImage(UIImage.iconHelpCircle?.withRenderingMode(.alwaysTemplate), for: .normal)
        tipsButton.setTitleColor(.secondaryBlack, for: .normal)
        tipsButton.imageView?.contentMode = .scaleAspectFit
        tipsButton.imageView?.tintColor = .secondaryBlack
        
        selectMediaInfoStackView.axis = .vertical
        selectMediaInfoStackView.alignment = .leading
        selectMediaInfoStackView.spacing = 4
        
        picker.delegate = self
        picker.videoExportPreset = AVAssetExportPresetPassthrough
        picker.videoQuality = .typeHigh
    }
    
    private func configureLayout() {
        view.addSubview(scrollView)
        scrollView.topToSuperview(offset: 24, usingSafeArea: true)
        scrollView.leftToSuperview(offset: 24)
        scrollView.rightToSuperview(offset: -24)
        scrollView.bottomToSuperview()
        scrollView.clipsToBounds = false
        
        /// Layout the selectMediaView
        
        scrollView.addSubview(selectMediaView)
        selectMediaView.leftToSuperview()
        selectMediaView.topToSuperview()
        selectMediaView.width(200)
        selectMediaView.height(200)
        
        /// Layout the selectMediaInfoView
        
        scrollView.addSubview(selectMediaInfoStackView)
        selectMediaInfoStackView.addSpace(24)
        selectMediaInfoStackView.addArrangedSubview(selectedMediaTitleLabel)
        selectMediaInfoStackView.addArrangedSubview(runTimeLabel)
        selectMediaInfoStackView.addArrangedSubview(tipsButton)
        
        runTimeLabel.height(18)
        tipsButton.height(16)
        
        selectMediaInfoStackView.leftToRight(of: selectMediaView, offset: 16)
        selectMediaInfoStackView.top(to: selectMediaView)
        selectMediaInfoStackView.width(100)
        
        /// Layout the editPostView
        
        scrollView.addSubview(editPostView)
        editPostView.topToBottom(of: selectMediaView)
        editPostView.widthToSuperview()
        editPostView.height(to: editPostView.verticalStackView)
        
        scrollView.addSubview(progressView)
        progressView.topToBottom(of: editPostView.uploadButton, offset: 20)
        progressView.centerXToSuperview()
        progressView.width(150)
        progressView.height(25)
    }
    
    private func configureBindings() {
        editPostView.uploadButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.uploadPost()
            })
            .disposed(by: disposeBag)
        
        editPostView.titleTextField.rx.controlEvent(.editingChanged)
            .map { [unowned self] in self.editPostView.titleTextField.text ?? "" }
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)
                
        editPostView.captionTextView.rx.text
            .compactMap { $0 }
            .bind(to: viewModel.caption)
            .disposed(by: disposeBag)
                
        viewModel.progress
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        viewModel.isUploading
            .map { !$0 }
            .bind(to: editPostView.uploadButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        selectMediaView.selectMediaButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.showMediaOptionsMenu()
            })
            .disposed(by: disposeBag)
        
        viewModel.mediaTypeTitle
            .bind(to: selectedMediaTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.viewTimeTitle
            .bind(to: runTimeLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.showingImage
            .map { !$0 }
            .bind(to: selectMediaView.imageMediaOverlay.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.showingVideo
            .map { !$0 }
            .bind(to: selectMediaView.videoMediaOverlay.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.showingMedia
            .map { $0 }
            .bind(to: selectMediaView.dashedBorderView.rx.isHidden,
                  selectMediaView.selectMediaButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.selectedMedia
            .compactMap { $0 }
            .subscribe(onNext: { media in
                print ("Media : \(media) selected")
                switch media {
                case .video(let url):
                    self.selectMediaView.videoMediaOverlay.playVideo(withURL: url, autoplay: false)
                case .image(let url):
                    self.selectMediaView.imageMediaOverlay.image = UIImage(contentsOfFile: url.path)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    @objc func dismissKeyboard() {
        editPostView.captionTextView.resignFirstResponder()
        editPostView.titleTextField.resignFirstResponder()
    }
}

// MARK: UIImagePickerControllerDelegate
extension NewPostCreateViewController: UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate {
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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

extension NewPostCreateViewController : MediaPickerAdapter {
    func selected(imageUrl url: URL) {
        // Image Selected
        viewModel.selectMedia(.image(url: url))
    }
    
    func selected(videoUrl url: URL) {
        // Video Selected
        viewModel.selectMedia(.video(url: url))
    }
}

//
//  NewPostGuideViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

//import UIKit
//import RxCocoa
//import RxSwift
//import SwiftRichString
//
//class NewPostGuideViewController: ViewController {
//    // MARK: View Model
//    private let viewModel = NewPostGuideViewModel()
//
//    // MARK: UI Components
//    let mainStackView = UIStackView()
//    let tipTitleLabel = UILabel()
//
//    let detailsStackView = UIStackView()
//    let hotTipsTitleLabel = UILabel()
//    let doNotShowAgainButton = UIButton()
//    let tipsBackgroundView = UIView()
//    let tipsList = UIStackView()
//    let selectButton = UIButton.standard(withTitle: LocalizedString.select)
//
//    // MARK: UIPickerController
//
//    struct TipData {
//        let icon: UIImage?
//        let text: NSAttributedString
//    }
//
//    let tipsListData: [TipData] = [
//        TipData(icon: UIImage(systemName: "paintbrush"),
//                text: "Upload or record in ".set(style: Style.title) +
//                    "portrait".set(style: Style.titleBold)),
//        TipData(icon: UIImage(systemName: "paintbrush"), text: "Keep it snappy".set(style: Style.title)),
//        TipData(icon: UIImage(systemName: "paintbrush"), text: "Remember, good sound and lighting!".set(style: Style.title))
//    ]
//
//    // MARK: UI Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "New Post"
//
//        // Do any additional setup after loading the view.
//        configureViews()
//        configureLayout()
//        style()
//        configureBindings()
//    }
//
//    // MARK: UI Configuration
//    private func configureViews() {
//        mainStackView.axis = .vertical
//        mainStackView.distribution = .equalSpacing
//        mainStackView.spacing = 10
//
//        detailsStackView.axis = .vertical
//        detailsStackView.distribution = .equalSpacing
//        detailsStackView.spacing = 10
//    }
//
//    private func configureLayout() {
//        view.addSubview(mainStackView)
//        mainStackView.centerInSuperview()
//        mainStackView.leftToSuperview(offset: 20)
//        mainStackView.rightToSuperview(offset: -20)
//
//        mainStackView.addArrangedSubview(tipTitleLabel)
//
//        detailsStackView.addSpace(10)
//        // Setup tips layout with stack views
//        tipsListData.forEach { tipData in
//            let horizontalStackView = UIStackView()
//
//            let imageView = UIImageView(image: tipData.icon)
//            imageView.contentMode = .scaleAspectFit
//            imageView.height(20)
//            imageView.width(30)
//
//            let label = UILabel()
//            label.attributedText = tipData.text
//
//            horizontalStackView.addArrangedSubview(imageView)
//            horizontalStackView.addArrangedSubview(label)
//            detailsStackView.addArrangedSubview(horizontalStackView)
//        }
//        detailsStackView.addSpace(10)
//
//        mainStackView.addArrangedSubview(tipsBackgroundView)
//        let selectButtonContainerView = UIView()
//        selectButtonContainerView.addSubview(selectButton)
//
//        mainStackView.addArrangedSubview(selectButtonContainerView)
//        selectButton.width(150)
//        selectButton.centerInSuperview()
//        selectButtonContainerView.height(to: selectButton)
//
//        tipsBackgroundView.addSubview(detailsStackView)
//        detailsStackView.edgesToSuperview()
//        tipsBackgroundView.height(to: detailsStackView)
//    }
//
//    private func style() {
//        detailsStackView.backgroundColor = .clear
//        tipsBackgroundView.layer.cornerRadius = 10
//        tipsBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//
//        tipTitleLabel.attributedText = LocalizedString.newPostTipsTitle.localized.set(style: Style.titleBold)
//    }
//}
