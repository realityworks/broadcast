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
    private let contentView = UIView()
    
    private let selectMediaView = SelectMediaView()
    private let selectMediaInfoStackView = UIStackView()
    private let runTimeLabel = UILabel()
    private let selectedMediaTitleLabel = UILabel.largeTitle(.noMedia, textColor: .primaryLightGrey)
    private let tipsButton = UIButton.text(withTitle: LocalizedString.tips)
    private let removeButton = UIButton.textDestructive(withTitle: LocalizedString.remove)
    
    private let progressView = ProgressView()
    private let editPostView = EditPostView()
    private let tipsView = TipsView()
    
    internal var picker = UIImagePickerController()
    
    // MARK: UIKit overrides
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar(styleAs: .dark(title: LocalizedString.newPost))
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        cancelBarButton.tintColor = .white
        navigationItem.leftBarButtonItem = cancelBarButton
        
        // Do any additional setup after loading the view.
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerForKeyboardEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterForKeyboardEvents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = contentView.frame.size
    }
    
    // MARK: Internal configuration functions
    
    private func configureViews() {
        view.addGestureRecognizer(dismissKeyboardGestureRecognizer)
        dismissKeyboardGestureRecognizer.delaysTouchesEnded = false
        dismissKeyboardGestureRecognizer.addTarget(self, action: #selector(dismissKeyboard))
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        tipsButton.setImage(UIImage.iconHelp?.withRenderingMode(.alwaysTemplate), for: .normal)
        tipsButton.setTitleColor(.secondaryBlack, for: .normal)
        tipsButton.imageView?.contentMode = .scaleAspectFit
        tipsButton.imageView?.tintColor = .secondaryBlack
        
        selectMediaInfoStackView.axis = .vertical
        selectMediaInfoStackView.alignment = .leading
        selectMediaInfoStackView.spacing = 4
        
        removeButton.contentHorizontalAlignment = .leading
        
        picker.delegate = self
        picker.videoExportPreset = AVAssetExportPresetPassthrough
        picker.videoQuality = .typeHigh
        
    }
    
    private func configureLayout() {
        view.addSubview(scrollView)
        scrollView.edgesToSuperview(usingSafeArea: true)
        scrollView.automaticallyAdjustsScrollIndicatorInsets = true
        
        /// ContentView
        scrollView.addSubview(contentView)
        contentView.topToSuperview(offset: 24)
        contentView.left(to: view, offset: 24)
        contentView.right(to: view, offset: -24)
        contentView.height(550)
        
        /// Layout the selectMediaView
        
        contentView.addSubview(selectMediaView)
        selectMediaView.leftToSuperview()
        selectMediaView.topToSuperview()
        selectMediaView.width(200)
        selectMediaView.height(200)
        
        /// Layout the selectMediaInfoView
        
        contentView.addSubview(selectMediaInfoStackView)
        selectMediaInfoStackView.addSpace(24)
        selectMediaInfoStackView.addArrangedSubview(selectedMediaTitleLabel)
        selectMediaInfoStackView.addArrangedSubview(runTimeLabel)
        selectMediaInfoStackView.addArrangedSubview(tipsButton)
        
        runTimeLabel.height(18)
        tipsButton.height(16)
        
        selectMediaInfoStackView.leftToRight(of: selectMediaView, offset: 16)
        selectMediaInfoStackView.top(to: selectMediaView)
        selectMediaInfoStackView.width(100)
        
        contentView.addSubview(removeButton)
        removeButton.leftToRight(of: selectMediaView, offset: 16)
        removeButton.bottom(to: selectMediaView, offset: -16)
        
        /// Layout the editPostView
        
        contentView.addSubview(editPostView)
        editPostView.topToBottom(of: selectMediaView, offset: 24)
        editPostView.widthToSuperview()
        editPostView.height(to: editPostView.verticalStackView)
        
        /// Layout progress and progress label views
        
        contentView.addSubview(progressView)
        
        progressView.topToBottom(of: editPostView.submitButton, offset: 20)
        progressView.widthToSuperview()
        
        /// Layout tips view
        view.addSubview(tipsView)
        tipsView.edgesToSuperview()
    }
    
    private func configureBindings() {
        
        configureTextFieldBindings()
        configureButtonBindings()
                        
        viewModel.progress
            .bind(to: progressView.rx.totalProgress)
            .disposed(by: disposeBag)
        
        viewModel.isUploading
            .map { !$0 }
            .bind(to: editPostView.titleTextField.rx.isEnabled, editPostView.captionTextView.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        viewModel.canUpload
            .bind(to: editPostView.submitButton.rx.isEnabled)
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
        
        viewModel.showingMedia
            .map { !$0 }
            .bind(to: removeButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.hideUploadingBar
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.progressString
            .bind(to: progressView.rx.text)
            .disposed(by: disposeBag)
            
        viewModel.selectedMedia
            .compactMap { $0 }
            .subscribe(onNext: { media in
                switch media {
                case .video(let url):
                    self.selectMediaView.videoMediaOverlay.playVideo(withURL: url, autoplay: false)
                case .image(let url):
                    self.selectMediaView.imageMediaOverlay.image = UIImage(contentsOfFile: url.path)
                }
                
            })
            .disposed(by: disposeBag)
        
        viewModel.showTips
            .map { !$0 }
            .bind(to: tipsView.rx.isHidden)
            .disposed(by: disposeBag)
        
        tipsView.closeButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.showTips(false)
            })
            .disposed(by: disposeBag)
        
        tipsButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.showTips(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureTextFieldBindings() {
        editPostView.titleTextField.rx.controlEvent(.editingChanged)
            .map { [unowned self] in self.editPostView.titleTextField.text ?? "" }
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)
        
        editPostView.titleTextField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: { [unowned self] _ in
                self.editPostView.titleTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)

        viewModel.title
            .subscribe(onNext: { text in
                self.editPostView.titleTextField.text = text
            })
            .disposed(by: disposeBag)
        
        viewModel.caption
            .subscribe(onNext: { text in
                self.editPostView.captionTextView.text = text
            })
            .disposed(by: disposeBag)
        
        editPostView.captionTextView.rx.text
            .compactMap { $0 }
            .bind(to: viewModel.caption)
            .disposed(by: disposeBag)
        
        removeButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.removeMedia()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureButtonBindings() {
        editPostView.submitButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismissKeyboard()
                self.viewModel.uploadPost()
            })
            .disposed(by: disposeBag)
        
        selectMediaView.selectMediaButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.showMediaOptionsMenu()
            })
            .disposed(by: disposeBag)
    }
    
    @objc func dismissKeyboard() {
        editPostView.captionTextView.resignFirstResponder()
        editPostView.titleTextField.resignFirstResponder()
    }
    
    @objc func cancelTapped() {
        showCancelOptions()
    }
    
    func showCancelOptions() {
        let alert = UIAlertController(
            title: LocalizedString.cancelChanges.localized,
            message: LocalizedString.cancelChangesDescription.localized,
            preferredStyle: .actionSheet)

        let actCancel = UIAlertAction(
            title: LocalizedString.no.localized,
            style: .default,
            handler: nil)
        alert.addAction(actCancel)

        let actClear = UIAlertAction(
            title: LocalizedString.yes.localized,
            style: .destructive,
            handler: { [weak self] action in
                self?.viewModel.clearContent()
            })
        alert.addAction(actClear)

        present(alert, animated: true, completion: nil)
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
    
    func picker(forTag tag: PickerTag = 0) -> UIImagePickerController {
        return picker
    }
}
