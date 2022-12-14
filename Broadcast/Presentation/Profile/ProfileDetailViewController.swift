//
//  ProfileDetailViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import UIKit
import AVKit
import MobileCoreServices
import RxSwift
import RxCocoa
import RxDataSources

class ProfileDetailViewController: ViewController, KeyboardEventsAdapter {
    var dismissKeyboardGestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer()
    typealias ProfileDetailSectionModel = SectionModel<LocalizedString?, ProfileDetailViewModel.Row>
    
    private let viewModel = ProfileDetailViewModel()
    
    private let refreshControl = UIRefreshControl()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let savingView = SavingView()
    private let titleHeaderView = UIView()
    private let titleLabel = UILabel.text(.profileDetailHeading,
                                  font: .tableTitle,
                                  textColor: .primaryLightGrey)
    private weak var trailerTableViewCell: UITableViewCell?
    
    let headingSeparator = UIView()
    
    // MARK: UIPickerController
    enum PickerTags: PickerTag {
        case profileImage   = 0
        case trailer        = 1
    }
    
    var pickers: [UIImagePickerController] = [
        UIImagePickerController(),
        UIImagePickerController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customBackButton()

        configureViews()
        configureLayout()
        configureBindings()
        
        /// Prepare date for use in the model
        viewModel.prepareData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerForKeyboardEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterForKeyboardEvents()
    }
    
    private func configureViews() {
        
        /// Configure text editing
        view.addGestureRecognizer(dismissKeyboardGestureRecognizer)
        dismissKeyboardGestureRecognizer.delaysTouchesEnded = false
        dismissKeyboardGestureRecognizer.addTarget(self, action: #selector(dismissKeyboard))

        // Configure Views
        // Register the required cells for the view
        tableView.register(ProfileInfoTableViewCell.self,
                           forCellReuseIdentifier: ProfileInfoTableViewCell.identifier)
        tableView.register(ProfileTextFieldTableViewCell.self,
                           forCellReuseIdentifier: ProfileTextFieldTableViewCell.identifier)
        tableView.register(ProfileTextViewTableViewCell.self,
                           forCellReuseIdentifier: ProfileTextViewTableViewCell.identifier)
        tableView.register(ProfileTrailerTableViewCell.self,
                           forCellReuseIdentifier: ProfileTrailerTableViewCell.identifier)
        tableView.register(ProfileSectionHeaderCell.self,
                           forCellReuseIdentifier: ProfileSectionHeaderCell.identifier)
        tableView.register(ProfileSimpleInfoTableViewCell.self,
                           forCellReuseIdentifier: ProfileSimpleInfoTableViewCell.identifier)

        // Setup the tableview styling
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none

        // Configure Bar button items
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(savePressed))

        //Setup the pickers
        pickers.forEach { picker in
            picker.delegate = self
            picker.videoExportPreset = AVAssetExportPresetPassthrough
            picker.videoQuality = .typeHigh
        }
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        view.addSubview(savingView)
        
        // Setup table view the header
        titleHeaderView.frame = CGRect(x: 0, y: 0, width: 200, height: 96)
        tableView.tableHeaderView = titleHeaderView

        titleHeaderView.addSubview(titleLabel)
        titleLabel.edgesToSuperview(excluding: [.left, .right])
        titleLabel.leftToSuperview(offset: 22)
        
        titleHeaderView.addSubview(headingSeparator)
        headingSeparator.edgesToSuperview(excluding: [.top])
        headingSeparator.height(1)
        
        tableView.edgesToSuperview()
        
        savingView.centerXToSuperview()
        savingView.topToSuperview(offset: 140, usingSafeArea: true)
    }
    
    private func configureBindings() {
        configureTableViewBindings()

        if let leftBarButtonItem = navigationItem.leftBarButtonItem {
            viewModel.isUploadingTrailer
                .map { !$0 }
                .bind(to: leftBarButtonItem.rx.isEnabled)
                .disposed(by: disposeBag)
        }
        
        viewModel.finishedSavingProfileSignal
            .subscribe(onNext: { [weak self] _ in
                self?.savingView.showFinished()
            })
            .disposed(by: disposeBag)

        viewModel.savingProfile
            .map { !$0 }
            .bind(to: savingView.rx.isHidden)
            .disposed(by: disposeBag)

        if let saveButton = navigationItem.rightBarButtonItem {
            viewModel.savingProfile
                .map { !$0 }
                .bind(to: saveButton.rx.isEnabled)
                .disposed(by: disposeBag)
        }
    }

    private func configureTableViewBindings() {
        let datasource = ReactiveTableViewModelSource<ProfileDetailSectionModel>(configureCell: { [weak self] _, tableView, indexPath, row -> UITableViewCell in
            guard let self = self else { return UITableViewCell() }

            switch row {
            case let .profileInfo(profileImage, displayName, subscribers):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.identifier, for: indexPath) as! ProfileInfoTableViewCell
                cell.configure(withProfileImage: profileImage,
                               displayName: displayName,
                               subscribers: subscribers)
                
                cell.changeThumbnailButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.dismissKeyboard()
                        self?.showMediaOptionsMenu(forTag: PickerTags.profileImage.rawValue)
                    })
                    .disposed(by: cell.disposeBag)

                self.viewModel.isUploadingProfileImage
                    .map { !$0 }
                    .bind(to: cell.loadingIndicator.rx.isHidden)
                    .disposed(by: cell.disposeBag)

                return cell

            case .displayName:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell

                let displayName = self.viewModel.displayNameSubject.value ?? .empty
                let title = LocalizedString.displayName.localized.uppercased()
                cell.configure(withTitle: title,
                               text: displayName,
                               placeholder: LocalizedString.displayName.localized,
                               editingEnabled: true)
                cell.rx.text
                    .bind(to: self.viewModel.displayNameSubject)
                    .disposed(by: cell.disposeBag)
                
                weak var weakCell = cell
                cell.rx.textFieldEditEnd
                    .subscribe(onNext: { _ in
                        weakCell?.textFieldResign()
                    })
                    .disposed(by: cell.disposeBag)
                
                self.viewModel.resignResponders
                    .subscribe(onNext: { _ in
                        weakCell?.textFieldResign()
                    })
                    .disposed(by: cell.disposeBag)

                return cell

            case .biography:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextViewTableViewCell.identifier, for: indexPath) as! ProfileTextViewTableViewCell

                let biography = self.viewModel.biographySubject.value ?? .empty
                cell.configure(withTitle: LocalizedString.displayBio.localized.uppercased(),
                               text: biography,
                               placeholder: LocalizedString.displayBio.localized)

                cell.rx.text
                    .bind(to: self.viewModel.biographySubject)
                    .disposed(by: cell.disposeBag)
                
                weak var weakCell = cell
                self.viewModel.resignResponders
                    .subscribe(onNext: { _ in
                        weakCell?.textViewResign()
                    })
                    .disposed(by: cell.disposeBag)

                return cell

            case .email(let email):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell

                cell.configure(withTitle: LocalizedString.email.localized.uppercased(),
                               text: email,
                               placeholder: LocalizedString.email.localized,
                               editingEnabled: false)

                return cell

            case .handle(let handle):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell

                cell.configure(withTitle: LocalizedString.userHandle.localized.uppercased(),
                               text: handle,
                               placeholder: LocalizedString.userHandle.localized,
                               editingEnabled: false)
                return cell

            case .trailerVideo:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTrailerTableViewCell.identifier, for: indexPath) as! ProfileTrailerTableViewCell

                self.configureBindings(forTrailerCell: cell)
                
                self.trailerTableViewCell = cell
                return cell

            case .simpleInfo(let text):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSimpleInfoTableViewCell.identifier, for: indexPath) as! ProfileSimpleInfoTableViewCell

                cell.configure(withText: text)

                return cell

            case .spacer:
                let cell = UITableViewCell()
                cell.backgroundColor = .white
                return cell
            }
        })

        datasource.heightForRowAtIndexPath = { [weak self] datasource, indexPath -> CGFloat in
            guard let self = self else { return 0 }

            let row = datasource[indexPath]
            switch row {
            case .profileInfo:
                return ProfileInfoTableViewCell.cellHeight
            case .displayName, .email, .handle:
                return ProfileTextFieldTableViewCell.cellHeight
            case .biography:
                return ProfileTextViewTableViewCell.cellHeight
            case .trailerVideo:
                return self.viewModel.showFailed.value ?
                    ProfileTrailerTableViewCell.failedUploadCellHeight :
                    ProfileTrailerTableViewCell.cellHeight
            case .simpleInfo:
                return ProfileSimpleInfoTableViewCell.cellHeight
            case .spacer(let height):
                return height
            }
        }

        datasource.heightForHeaderInSection = { datasource, section -> CGFloat in
            switch section {
            /// The first cell (No header)
            case 0:
                return 0
            default:
                return ProfileSectionHeaderCell.cellHeight
            }
        }

        datasource.viewForHeaderInSection = { datasource, tableView, section in
            switch section {
            /// The first cell (No header)
            case 0:
                return nil
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSectionHeaderCell.identifier) as? ProfileSectionHeaderCell else { return nil }

                let sectionTitle = datasource.sectionModels[section].model
                cell.label.text = sectionTitle?.localized

                return cell
            }
        }

        let items = Observable.combineLatest(
            viewModel.biographyObservable,
            viewModel.displayNameObservable,
            viewModel.emailObservable,
            viewModel.handleObservable,
            viewModel.subscriberCount,
            viewModel.profileImage,
            viewModel.showFailed) {

            biography, displayName, email, handle, subscribers, profileImage, showFailed -> [ProfileDetailSectionModel] in
            return [
                SectionModel(model: nil, items: [
                                ProfileDetailViewModel.Row.profileInfo(profileImage: profileImage,
                                                                       displayName: displayName ?? String.empty,
                                                                       subscribers: subscribers)]),
                SectionModel(model: LocalizedString.accountSettings, items: [
                                ProfileDetailViewModel.Row.displayName(text: displayName ?? String.empty),
                                ProfileDetailViewModel.Row.biography(text: biography ?? String.empty),
                                ProfileDetailViewModel.Row.email(text: email ?? String.empty),
                                ProfileDetailViewModel.Row.handle(text: handle ?? String.empty),
                                ProfileDetailViewModel.Row.spacer(height: 16),
                                ProfileDetailViewModel.Row.simpleInfo(text: LocalizedString.emailUserLockedInfo)]),
                SectionModel(model: LocalizedString.trailerVideo, items: [
                                ProfileDetailViewModel.Row.trailerVideo])
            ]
        }

        items
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)

        tableView.delegate = datasource
    }

    private func configureBindings(forTrailerCell cell: ProfileTrailerTableViewCell) {
        viewModel.showingTrailer
            .map { $0 }
            .bind(to: cell.selectMediaView.dashedBorderView.rx.isHidden)
            .disposed(by: cell.disposeBag)

        viewModel.progressText
            .bind(to: cell.progressView.rx.text)
            .disposed(by: cell.disposeBag)

        viewModel.progress
            .bind(to: cell.progressView.rx.totalProgress)
            .disposed(by: cell.disposeBag)

        viewModel.showingTrailer
            .map { !$0 }
            .bind(to: cell.selectMediaView.videoMediaOverlay.rx.isHidden)
            .disposed(by: cell.disposeBag)

        viewModel.mediaTypeTitle
            .bind(to: cell.selectedMediaTitleLabel.rx.text)
            .disposed(by: cell.disposeBag)

        viewModel.runTimeTitle
            .bind(to: cell.runTimeLabel.rx.attributedText)
            .disposed(by: cell.disposeBag)

        viewModel.isUploadingTrailer
            .map { !$0 }
            .bind(to: cell.changeButton.rx.isEnabled)
            .disposed(by: cell.disposeBag)

        viewModel.showProgressView
            .map { !$0 }
            .bind(to: cell.progressView.rx.isHidden)
            .disposed(by: cell.disposeBag)

        viewModel.showUploadButton
            .map { !$0 }
            .bind(to: cell.uploadButton.rx.isHidden)
            .disposed(by: cell.disposeBag)

        viewModel.uploadComplete
            .bind(to: cell.progressView.rx.uploadSuccess)
            .disposed(by: cell.disposeBag)
        
        viewModel.showingTrailer
            .map { !$0 }
            .bind(to: cell.changeButton.rx.isHidden)
            .disposed(by: cell.disposeBag)
        
        cell.selectMediaView.selectMediaButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismissKeyboard()
                self?.showMediaOptionsMenu(forTag: PickerTags.trailer.rawValue)
            })
            .disposed(by: cell.disposeBag)

        cell.changeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismissKeyboard()
                self?.showMediaOptionsMenu(forTag: PickerTags.trailer.rawValue)
            })
            .disposed(by: cell.disposeBag)

        viewModel.selectedTrailerUrl
            .map { $0 != nil }
            .bind(to: cell.uploadButton.rx.isEnabled)
            .disposed(by: cell.disposeBag)

        cell.uploadButton.rx.tap
            .withLatestFrom(viewModel.selectedTrailerUrl)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] url in
                self?.viewModel.uploadTrailer(withUrl: url)
            })
            .disposed(by: cell.disposeBag)

        viewModel.showFailed
            .bind(to: cell.rx.failed)
            .disposed(by: cell.disposeBag)

        viewModel.showTrailerProcessing
            .bind(to: cell.rx.showTrailerProcessing)
            .disposed(by: cell.disposeBag)
        
        weak var weakCell = cell
        viewModel.trailerThumbnailUrl
            .compactMap { $0 }
            .subscribe(onNext: { url in
                weakCell?.thumbnailImageView.sd_setImage(with: url)
            })
            .disposed(by: cell.disposeBag)
        
        viewModel.trailerVideoUrl
            .compactMap { $0 }
            .subscribe(onNext: { url in
                weakCell?.selectMediaView.videoMediaOverlay.playVideo(withURL: url, autoplay: false)
            })
            .disposed(by: cell.disposeBag)
    }
}

// MARK: - Objc Handlers

extension ProfileDetailViewController {
    @objc func savePressed() {
        dismissKeyboard()
        viewModel.updateProfile()
    }
    
    @objc func dismissKeyboard() {
        viewModel.willResignResponders()
    }
}

// MARK: UIImagePickerControllerDelegate

extension ProfileDetailViewController: UIImagePickerControllerDelegate,
                                      UINavigationControllerDelegate {
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage ?? info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let data = image.orientationRemoved().jpegData(compressionQuality: 9) {
            let imageUrl = FileManager.default.documentsDirectory().appendingPathComponent("thumbnail.jpg")
            try? data.write(to: imageUrl)
            selected(imageUrl: imageUrl)
        } else if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL,
                  let srcData = try? Data(contentsOf: imageUrl),
                  let data = UIImage(data: srcData)?.orientationRemoved().jpegData(compressionQuality: 9) {
            let imageUrl = FileManager.default.documentsDirectory().appendingPathComponent("thumbnail.jpg")
            try? data.write(to: imageUrl)
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

extension ProfileDetailViewController : MediaPickerAdapter {
    func supportedAlbumModes(forTag tag: PickerTag) -> [String] {
        switch tag {
        case PickerTags.profileImage.rawValue:
            // Profile image supports
            return [kUTTypeImage as String]
        case PickerTags.trailer.rawValue:
            // Trailer only supports video
            return [kUTTypeMovie as String]
        default:
            return []
        }
    }

    func supportedCameraModes(forTag tag: PickerTag) -> [String] {

        switch tag {
        case PickerTags.profileImage.rawValue:
            // Profile image supports
            return [kUTTypeImage as String]
        case PickerTags.trailer.rawValue:
            // Trailer only supports video
            return [kUTTypeMovie as String]
        default:
            return []
        }
    }

    func selected(imageUrl url: URL) {
        viewModel.profileImageSelected(withUrl: url)
    }

    func selected(videoUrl url: URL) {
        // Video Selected
        viewModel.trailerSelected(withUrl: url)
    }

    func picker(forTag tag: PickerTag) -> UIImagePickerController {
        return pickers[tag]
    }
}

