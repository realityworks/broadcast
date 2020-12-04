//
//  ProfileDetailViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ProfileDetailViewController: ViewController {
    typealias ProfileDetailSectionModel = SectionModel<LocalizedString?, ProfileDetailViewModel.Row>
    
    private let viewModel = ProfileDetailViewModel()
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Profile Detail"
        
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    private func configureViews() {
        tableView.register(ProfileInfoTableViewCell.self,
                           forCellReuseIdentifier: ProfileInfoTableViewCell.identifier)
        tableView.register(ProfileTextFieldTableViewCell.self,
                           forCellReuseIdentifier: ProfileTextFieldTableViewCell.identifier)
        tableView.register(ProfileTrailerTableViewCell.self,
                           forCellReuseIdentifier: ProfileTrailerTableViewCell.identifier)
        tableView.register(ProfileSectionHeaderCell.self,
                           forCellReuseIdentifier: ProfileSectionHeaderCell.identifier)
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
    
    private func configureBindings() {
        let datasource = ReactiveTableViewModelSource<ProfileDetailSectionModel>(configureCell: { _, tableView, indexPath, row -> UITableViewCell in
            
            switch row {
            case .profileInfo:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.identifier, for: indexPath) as! ProfileInfoTableViewCell
                v
                return cell
            case .displayName:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell
//                cell.configure(withTitle: LocalizedString.profileInformation,
//                               icon: UIImage(systemName: "person.fill"))
                return cell
            case .biography:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell
//                cell.configure(withTitle: LocalizedString.profileInformation,
//                               icon: UIImage(systemName: "person.fill"))
                return cell
            case .trailerVideo:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTrailerTableViewCell.identifier, for: indexPath) as! ProfileTrailerTableViewCell
//                cell.configure(withTitle: LocalizedString.profileInformation,
//                               icon: UIImage(systemName: "person.fill"))
                return cell
            }
        })

        datasource.heightForRowAtIndexPath = { datasource, indexPath -> CGFloat in
            ProfileTableViewCell.cellHeight
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
            viewModel.thumbnail) {
            
            biography, displayName, subscribers, thumbnail -> [ProfileDetailSectionModel] in
            
            return [
                SectionModel(model: nil, items: [
                                ProfileDetailViewModel.Row.profileInfo]),
                SectionModel(model: LocalizedString.displayName, items: [
                                ProfileDetailViewModel.Row.displayName]),
                SectionModel(model: LocalizedString.displayBio, items: [
                                ProfileDetailViewModel.Row.biography]),
                 SectionModel(model: LocalizedString.trailerVideo, items: [
                                 ProfileDetailViewModel.Row.trailerVideo])
            ]
        }
                
        items
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.delegate = datasource
    }
}

