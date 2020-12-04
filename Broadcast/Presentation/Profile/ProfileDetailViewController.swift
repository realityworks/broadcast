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
        setupDatasourceBindings()
        setupTableViewBindings()
    }
    
    private func setupDatasourceBindings() {
        let datasource = ReactiveTableViewModelSource<SectionModel<LocalizedString, ProfileDetailViewModel.Row>>(configureCell: { _, tableView, indexPath, row -> UITableViewCell in
            
            switch row {
            case .profileInfo:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.identifier, for: indexPath) as! ProfileInfoTableViewCell
//                cell.configure(withTitle: LocalizedString.profileInformation,
//                               icon: UIImage(systemName: "person.fill"))
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
            case .trailerSelection:
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
            cell.label.text = sectionTitle.localized
            
            return cell
        }
        
        let items: Observable<[SectionModel<LocalizedString?, ProfileViewModel.Row>]> = Observable.just(
            [
                #warning("TODO : Setup correct model")
                SectionModel(model: nil, items: [
                                ProfileDetailViewModel.Row.profileInfo]),
                SectionModel(model: LocalizedString.support, items: [
                                ProfileViewModel.Row.frequentlyAskedQuestions]),
                SectionModel(model: LocalizedString.legal, items: [
                                ProfileViewModel.Row.privacyPolicy,
                                ProfileViewModel.Row.termsAndConditions,
                                ProfileViewModel.Row.share,
                                ProfileViewModel.Row.logout]),
            ])
        
        items
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.delegate = datasource
    }
}

