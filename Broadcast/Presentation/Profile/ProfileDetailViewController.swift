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

class ProfileDetailViewController: ViewController {
    typealias ProfileDetailSectionModel = SectionModel<LocalizedString?, ProfileDetailViewModel.Row>
    
    private let viewModel = ProfileDetailViewModel()
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
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

        // Do any additional setup after loading the view.
        title = "Profile Detail"
        
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    private func configureViews() {
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
        
        // Setup the tableview styling
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        
        // Configure Bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePressed))
        
        //Setup the pickers
        pickers.forEach { picker in
            picker.delegate = self
            picker.videoExportPreset = AVAssetExportPresetPassthrough
            picker.videoQuality = .typeHigh
        }
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
    
    private func configureBindings() {
        let datasource = ReactiveTableViewModelSource<ProfileDetailSectionModel>(configureCell: { _, tableView, indexPath, row -> UITableViewCell in
            
            switch row {
            case let .profileInfo(profileImageUrl, subscribers):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.identifier, for: indexPath) as! ProfileInfoTableViewCell
                cell.configure(withProfileImageUrl: profileImageUrl, subscribers: subscribers)
                cell.changeThumbnailButton.rx.tap
                    .subscribe(onNext: {
                        self.showMediaOptionsMenu(forTag: PickerTags.profileImage.rawValue)
                    })
                    .disposed(by: self.disposeBag)
                return cell
            case .displayName(let displayName):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell
                
                cell.configure(withText: displayName,
                               icon: UIImage(systemName: "pencil")?.withRenderingMode(.alwaysTemplate))
                cell.rx.text
                    .bind(to: self.viewModel.displayNameSubject)
                    .disposed(by: self.disposeBag)
                
                return cell
            case .biography(let biography):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextViewTableViewCell.identifier, for: indexPath) as! ProfileTextViewTableViewCell
                
                cell.configure(withText: biography,
                               icon: UIImage(systemName: "pencil")?.withRenderingMode(.alwaysTemplate))
                
                cell.rx.text
                    .bind(to: self.viewModel.biographySubject)
                    .disposed(by: self.disposeBag)
                
                return cell
            case let .trailerVideo(trailerVideoUrl):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTrailerTableViewCell.identifier, for: indexPath) as! ProfileTrailerTableViewCell
                
                cell.configure(trailerVideoUrl: trailerVideoUrl)
                cell.selectButton.rx.tap
                    .subscribe(onNext: { [unowned self] _ in
                        self.showMediaOptionsMenu(forTag: PickerTags.trailer.rawValue)
                    })
                    .disposed(by: self.disposeBag)
                
                return cell
            }
        })

        datasource.heightForRowAtIndexPath = { datasource, indexPath -> CGFloat in
            let row = datasource[indexPath]
            switch row {
            case .profileInfo:
                return ProfileInfoTableViewCell.cellHeight
            case .displayName:
                return 50
            case .biography:
                return 80
            case .trailerVideo:
                return UITableView.automaticDimension
            }
        }
        datasource.heightForHeaderInSection = { _, _ -> CGFloat in
            ProfileSectionHeaderCell.cellHeight
        }
        
        datasource.viewForHeaderInSection = { datasource, tableView, section in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSectionHeaderCell.identifier) as? ProfileSectionHeaderCell else { return nil }
            
            let sectionTitle = datasource.sectionModels[section].model
            cell.label.text = sectionTitle?.localized
            
            return cell
        }
        
        let items = Observable.combineLatest(
            viewModel.biographyObservable,
            viewModel.displayNameObservable,
            viewModel.subscriberCount,
            viewModel.profileImageUrl,
            viewModel.trailerVideoUrl) {
            
            biography, displayName, subscribers, profileImageUrl, trailerUrl -> [ProfileDetailSectionModel] in
            
            return [
                SectionModel(model: nil, items: [
                                ProfileDetailViewModel.Row.profileInfo(profileImageUrl: profileImageUrl, subscribers: subscribers)]),
                SectionModel(model: LocalizedString.displayName, items: [
                                ProfileDetailViewModel.Row.displayName(text: displayName ?? String.empty)]),
                SectionModel(model: LocalizedString.displayBio, items: [
                                ProfileDetailViewModel.Row.biography(text: biography ?? String.empty)]),
                SectionModel(model: LocalizedString.trailerVideo, items: [
                                ProfileDetailViewModel.Row.trailerVideo(trailerUrl: trailerUrl)])
            ]
        }
                
        items
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.delegate = datasource
    }
}

// MARK: - Objc Handlers

extension ProfileDetailViewController {
    @objc func savePressed() {
        viewModel.updateProfile()
    }
}

// MARK: UIImagePickerControllerDelegate

extension ProfileDetailViewController: UIImagePickerControllerDelegate,
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

