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
    var picker = UIImagePickerController()
    
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
        
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        
        // Configure Bar button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePressed))
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
                return cell
            case .displayName:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell
                
                self.viewModel.displayNameSubject
                    .asObservable()
                    .bind(to: cell.rx.text)
                    .disposed(by: self.disposeBag)
                
                cell.rx.text
                    .compactMap { $0 }
                    .bind(to: self.viewModel.displayNameSubject)
                    .disposed(by: self.disposeBag)
                
                return cell
            case .biography:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextViewTableViewCell.identifier, for: indexPath) as! ProfileTextViewTableViewCell
                
                self.viewModel.biographySubject
                    .bind(to: cell.rx.text)
                    .disposed(by: self.disposeBag)
                
                cell.rx.text
                    .compactMap { $0 }
                    .bind(to: self.viewModel.biographySubject)
                    .disposed(by: self.disposeBag)
                
                return cell
            case let .trailerVideo(trailerVideoUrl):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTrailerTableViewCell.identifier, for: indexPath) as! ProfileTrailerTableViewCell
                
                cell.configure(trailerVideoUrl: trailerVideoUrl)
                cell.selectButton.rx.tap
                    .subscribe(onNext: { [unowned self] _ in
                        self.showMediaOptionsMenu()
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
            viewModel.biography,
            viewModel.displayName,
            viewModel.subscribers,
            viewModel.profileImageUrl,
            viewModel.trailerVideoUrl) {
            
            biography, displayName, subscribers, profileImageUrl, trailerUrl -> [ProfileDetailSectionModel] in
            
            return [
                SectionModel(model: nil, items: [
                                ProfileDetailViewModel.Row.profileInfo(profileImageUrl: profileImageUrl, subscribers: subscribers)]),
                SectionModel(model: LocalizedString.displayName, items: [
                                ProfileDetailViewModel.Row.displayName(text: displayName)]),
                SectionModel(model: LocalizedString.displayBio, items: [
                                ProfileDetailViewModel.Row.biography(text: biography)]),
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
    func supportedAlbumModes() -> [String] {
        // Trailer only supports video
        return [kUTTypeMovie as String]
    }
    
    func supportedCameraModes() -> [String] {
        // Trailer only supports video
        return [kUTTypeMovie as String]
    }
    
    func selected(imageUrl url: URL) {
        // DO NOTHING, Image not supported
    }
    
    func selected(videoUrl url: URL) {
        // Video Selected
        viewModel.trailerSelected(withUrl: url)
    }
}

