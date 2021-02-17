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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.loadProfile()
    }
    
    private func configureViews() {
        tableView.register(ProfileTableViewCell.self,
                           forCellReuseIdentifier: ProfileTableViewCell.identifier)
        tableView.register(ProfileSignOutTableViewCell.self,
                           forCellReuseIdentifier: ProfileSignOutTableViewCell.identifier)
        tableView.register(ProfileVersionTableViewCell.self,
                           forCellReuseIdentifier: ProfileVersionTableViewCell.identifier)
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
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: false)
    }
    
    private func configureBindings() {
        setupDatasourceBindings()
        setupTableViewBindings()
        
        viewModel.shareProfileSignal
            .withLatestFrom(viewModel.profileHandle)
            .subscribe(onNext: { [self] handle in
                let items = [Configuration.siteURL.appendingPathComponent(handle)]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(ac, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.sendLogSignal
            .subscribe(onNext: { [self] _ in
                let fileUrl = Logger.saveFile("Log_\(Date.now.asAppDateTimeString()).txt")
                let ac = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
                self.present(ac, animated: true)
            })
            .disposed(by: disposeBag)
            
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
            case .sendLog:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
                cell.configure(withTitle: LocalizedString.sendLog,
                               icon: UIImage.iconShare,
                               leftInset: 0)
                return cell
            case .logout:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSignOutTableViewCell.identifier, for: indexPath) as! ProfileSignOutTableViewCell
                
                return cell
            case .version:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileVersionTableViewCell.identifier, for: indexPath) as! ProfileVersionTableViewCell
                
                return cell
            }
        })

        datasource.heightForRowAtIndexPath = { datasource, indexPath -> CGFloat in
            let row = datasource[indexPath]
            switch row {
            case .logout:
                return ProfileSignOutTableViewCell.cellHeight
            case .version:
                return ProfileVersionTableViewCell.cellHeight
            default:
                return ProfileTableViewCell.cellHeight
            }
        }
        datasource.heightForHeaderInSection = { datasource, section -> CGFloat in
            guard section != ProfileViewModel.Sections.logout.rawValue else { return 32 }
            
            return ProfileSectionHeaderCell.cellHeight
        }
        
        datasource.viewForHeaderInSection = { datasource, tableView, section in
            guard section != ProfileViewModel.Sections.logout.rawValue else { return nil }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileSectionHeaderCell.identifier) as? ProfileSectionHeaderCell else { return nil }
            
            let sectionTitle = datasource.sectionModels[section].model
            cell.label.text = sectionTitle.localized
            
            return cell
        }
        
        #warning("Add line sendlog item per target")
        let items: Observable<[SectionModel<LocalizedString, ProfileViewModel.Row>]> = Observable.just(
            [
                SectionModel(model: LocalizedString.accountSettings, items: [
                                ProfileViewModel.Row.detail,
                                ProfileViewModel.Row.stripeAccount,
                                ProfileViewModel.Row.share]),
                SectionModel(model: LocalizedString.support, items: [
                                ProfileViewModel.Row.frequentlyAskedQuestions,
                                ProfileViewModel.Row.privacyPolicy,
                                ProfileViewModel.Row.termsAndConditions]),
                SectionModel(model: LocalizedString.logout, items: [
                                ProfileViewModel.Row.sendLog,
                                ProfileViewModel.Row.logout,
                                ProfileViewModel.Row.version])
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
            .observe(on: Schedulers.standard.main)
            .subscribe(onNext: { [self] row in
                switch row {
                case .detail:
                    navigationController?.push(with: .profileDetail)
                case .stripeAccount:
                    navigationController?.push(with: .stripeAccount)
                case .frequentlyAskedQuestions:
                    UIApplication.shared.open(Configuration.faq)
                case .privacyPolicy:
                    UIApplication.shared.open(Configuration.privacyPolicy)
                    break
                case .termsAndConditions:
                    UIApplication.shared.open(Configuration.broadcasterTermsAndConditions)
                    break
                case .share:
                    self.viewModel.shareProfile()
                    break
                case .sendLog:
                    self.viewModel.sendLog()
                case .logout:
                    self.viewModel.logout()
                case .version:
                    break /// Do nothing
                }
            })
            .disposed(by: disposeBag)
    }
}
