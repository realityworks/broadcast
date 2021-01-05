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
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar(styleAs: .dark(title: LocalizedString.myProfile))
        
        configureViews()
        configureLayout()
        configureBindings()
        
        viewModel.loadProfile()
    }
    
    private func configureViews() {
        tableView.register(ProfileTableViewCell.self,
                           forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.register(ProfileSignOutTableViewCell.self,
                           forCellReuseIdentifier: ProfileSignOutTableViewCell.identifier)
        tableView.register(ProfileSectionHeaderCell.self,
                           forCellReuseIdentifier: ProfileSectionHeaderCell.identifier)
        
        /// Header view for a grouped table view needs to have a frame with the smallest possible value,
        /// otherwise the grouped table view automatically sets up a header.
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)

        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = .zero
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        view.backgroundColor = UIColor.secondaryWhite
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: false)
    }
    
    private func configureBindings() {
        setupDatasourceBindings()
        setupTableViewBindings()
    }
    
    private func setupDatasourceBindings() {
        let datasource = ReactiveTableViewModelSource<SectionModel<LocalizedString, ProfileViewModel.Row>>(configureCell: { _, tableView, indexPath, row -> UITableViewCell in
            
            switch row {
            case .detail:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
                cell.configure(withTitle: LocalizedString.profileInformation,
                               icon: UIImage.iconProfile,
                               showDisclosure: true)
                return cell
            case .stripeAccount:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
                cell.configure(withTitle:  LocalizedString.subscription,
                               icon: UIImage.iconCreditCard,
                               showDisclosure: true)
                return cell
            case .frequentlyAskedQuestions:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
                cell.configure(withTitle: LocalizedString.frequentlyAskedQuestions,
                               icon: UIImage.iconHelp)
                return cell
            case .privacyPolicy:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
                cell.configure(withTitle: LocalizedString.privacyPolicy,
                               icon: UIImage.iconEye)
                return cell
            case .termsAndConditions:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
                cell.configure(withTitle: LocalizedString.termsAndConditions,
                               icon: UIImage.iconDocument,
                               leftInset: 0)
                return cell
            case .share:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
                cell.configure(withTitle: LocalizedString.shareProfile,
                               icon: UIImage.iconShare,
                               leftInset: 0)
                return cell
            case .logout:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSignOutTableViewCell.identifier, for: indexPath) as! ProfileSignOutTableViewCell
                
                cell.button.rx.tap
                    .subscribe(onNext: { _ in
                        self.viewModel.logout()
                    })
                    .disposed(by: self.disposeBag)
                
                return cell
            }
        })

        datasource.heightForRowAtIndexPath = { datasource, indexPath -> CGFloat in
            let row = datasource[indexPath]
            switch row {
            case .logout:
                return ProfileSignOutTableViewCell.cellHeight
            default:
                return ProfileTableViewCell.cellHeight
            }
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
                                ProfileViewModel.Row.stripeAccount,
                                ProfileViewModel.Row.share]),
                SectionModel(model: LocalizedString.support, items: [
                                ProfileViewModel.Row.frequentlyAskedQuestions,
                                ProfileViewModel.Row.privacyPolicy,
                                ProfileViewModel.Row.termsAndConditions,
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
                    self?.viewModel.logout()
                }
            })
            .disposed(by: disposeBag)
    }
}
