//
//  ProfileDetailViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import UIKit
import RxSwift
import RxCocoa

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
        let datasource = ReactiveTableViewModelSource<SectionModel<LocalizedString, ProfileViewModel.Row>>(configureCell: { _, tableView, indexPath, row -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
            
            switch row {
            case .detail:
                cell.configure(withTitle: LocalizedString.profileInformation,
                               icon: UIImage(systemName: "person.fill"))
            case .stripeAccount:
                cell.configure(withTitle:  LocalizedString.subscription,
                               icon: UIImage(systemName: "creditcard.fill"))
            case .frequentlyAskedQuestions:
                cell.configure(withTitle: LocalizedString.frequentlyAskedQuestions,
                               icon: UIImage(systemName: "questionmark"))
            case .privacyPolicy:
                cell.configure(withTitle: LocalizedString.privacyPolicy,
                               icon: nil)
            case .termsAndConditions:
                cell.configure(withTitle: LocalizedString.termsAndConditions,
                               icon: nil)
            case .share:
                cell.configure(withTitle: LocalizedString.shareProfile,
                               icon: UIImage(systemName: "square.and.arrow.up"))
            case .logout:
                cell.configure(withTitle: LocalizedString.logout,
                               titleColor: .red)
            }
            return cell
        })

        datasource.heightForRowAtIndexPath = { _, _ -> CGFloat in
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
        
        let items: Observable<[SectionModel<LocalizedString, ProfileViewModel.Row>]> = Observable.just(
            [
                SectionModel(model: LocalizedString.accountSettings, items: [
                                ProfileViewModel.Row.detail,
                                ProfileViewModel.Row.stripeAccount]),
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
    
    private func setupTableViewBindings() {
        // TableView selection
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] (indexPath: IndexPath) in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ProfileViewModel.Row.self)
            .observeOn(Schedulers.standard.main)
            .subscribe(onNext: { [weak self] row in
                switch row {
                case .detail:
                    self?.navigationController?.push(with: .profileDetail)
                case .stripeAccount:
                    self?.navigationController?.push(with: .stripeAccount)
                case .frequentlyAskedQuestions:
                    #warning("TODO - Link out to a webpage")
                    break
                case .privacyPolicy:
                    #warning("TODO - Link out to a webpage")
                    break
                case .termsAndConditions:
                    #warning("TODO - Link out to a webpage")
                    break
                case .share:
                    #warning("TODO - Setup sharing")
                    break
                case .logout:
                    #warning("TODO - Setup authentication and logout")
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

