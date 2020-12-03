//
//  ProfileViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class ProfileViewController: ViewController {
    private let viewModel = ProfileViewModel()
    
    typealias Datasource = ReactiveTableViewModelSource<SectionModel<String?, ProfileViewModel.Row>>
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Profile"
        
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    private func configureViews() {
        tableView.register(ProfileTableViewCell.self,
                           forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
    }
    
    private func configureLayout() {
        
    }
    
    private func configureBindings() {
        let datasource = Datasource(configureCell: { _, tableView, indexPath, row -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
            
            switch row {
            case .detail:
                cell.configure(withTitle: LocalizedString.profileInformation,
                               icon: UIImage(systemName: "link.circle"))
            case .subscription:
                cell.configure(withTitle:  LocalizedString.subscription,
                               icon: UIImage(systemName: "link.circle"))
            case .frequentlyAskedQuestions:
                cell.configure(withTitle: LocalizedString.frequentlyAskedQuestions,
                               icon: UIImage(systemName: "link.circle"))
            case .privacyPolicy:
                cell.configure(withTitle: LocalizedString.privacyPolicy,
                               icon: UIImage(systemName: "link.circle"))
            case .termsAndConditions:
                cell.configure(withTitle: LocalizedString.termsAndConditions,
                               icon: UIImage(systemName: "link.circle"))
            case .share:
                cell.configure(withTitle: LocalizedString.shareProfile,
                               icon: UIImage(systemName: "link.circle"))
            case .logout:
                cell.configure(withTitle: LocalizedString.logout,
                               titleColor: .red)
            }
            return cell
        })
        
        datasource.viewForHeaderInSection = { dataSource, tableView, section -> UIView? in
            guard let sectionTitle = dataSource.sectionModels[section].model,
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSectionHeaderCell.identifier) as? ProfileSectionHeaderCell else { return nil }
            cell.label.text = sectionTitle
            return cell
        }

        dataSource.heightForHeaderInSection = { $0.sectionModels[$1].model != nil ? SettingsSectionHeaderCell.cellHeight : 0 }
        
        let items = Observable.just(
            [
                SectionModel(model: "ACCOUNT SETTINGS", items:
                                []),
                SectionModel(model: "SUPPORT", items: []),
                SectionModel(model: "LEGAL", items: []),
            ])
    }
    
}
