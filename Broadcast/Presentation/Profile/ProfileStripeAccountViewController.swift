//
//  ProfileStripeAccountViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ProfileStripeAccountViewController: ViewController {
    typealias ProfileStripeAccountSectionModel =
        SectionModel<LocalizedString, ProfileStripeAccountViewModel.Row>
    
    private let viewModel = ProfileStripeAccountViewModel()
    
    private let titleHeaderView = UIView()
    private let titleLabel = UILabel.text(.profileStripeAccountHeading,
                                  font: .tableTitle,
                                  textColor: .primaryLightGrey)
    private let headingSeparator = UIView()

    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customBackButton()
        
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    private func configureViews() {
        // Setup table view the header
        titleHeaderView.frame = CGRect(x: 0, y: 0, width: 200, height: 96)
        tableView.tableHeaderView = titleHeaderView

        titleHeaderView.addSubview(titleLabel)
        titleLabel.edgesToSuperview(excluding: [.left, .right])
        titleLabel.leftToSuperview(offset: 22)
        
        titleHeaderView.addSubview(headingSeparator)
        headingSeparator.edgesToSuperview(excluding: [.top])
        headingSeparator.height(1)
        
        // Configure Views
        tableView.register(ProfileTextFieldTableViewCell.self,
                           forCellReuseIdentifier: ProfileTextFieldTableViewCell.identifier)
        
        tableView.register(ProfileSimpleInfoTableViewCell.self,
                           forCellReuseIdentifier: ProfileSimpleInfoTableViewCell.identifier)
        
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
    
    private func configureBindings() {
        let datasource = ReactiveTableViewModelSource<ProfileStripeAccountSectionModel>(configureCell: { _, tableView, indexPath, row -> UITableViewCell in
            
            switch row {
            case let .productId(text):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell
                
                cell.configure(withTitle: LocalizedString.id.localized.uppercased(),
                               text: text,
                               editingEnabled: false,
                               showLockIcon: true)
                return cell
                
            case let .pricing(text):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell
                
                cell.configure(withTitle: LocalizedString.pricing.localized.uppercased(),
                               text: text,
                               editingEnabled: false,
                               showLockIcon: true)
                return cell
                
            case let .totalBalance(text):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell
                
                cell.configure(withTitle: LocalizedString.totalBalance.localized.uppercased(),
                               text: text,
                               editingEnabled: false,
                               showLockIcon: true)
                return cell
                
            case let .lifetimeTotalVolume(text):
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell
                
                cell.configure(withTitle: LocalizedString.lifetimeTotalVolume.localized.uppercased(),
                               text: text,
                               editingEnabled: false,
                               showLockIcon: true)
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
        
        datasource.heightForRowAtIndexPath = { datasource, indexPath -> CGFloat in
            let row = datasource[indexPath]
            switch row {
            case .simpleInfo:
                return ProfileSimpleInfoTableViewCell.cellHeight
            case .spacer(let height):
                return height
            default:
                return ProfileTextFieldTableViewCell.cellHeight
            }
        }
                
        let items = Observable.combineLatest(
            viewModel.productIdObseravable,
            viewModel.pricingObservable,
            viewModel.totalBalanceObservable,
            viewModel.lifetimeTotalVolumeObservable) {
            
            productId, pricing, _, _ -> [ProfileStripeAccountSectionModel] in
            
            return [
                SectionModel(model: LocalizedString.id, items: [
                                ProfileStripeAccountViewModel.Row.productId(text: productId),
                                ProfileStripeAccountViewModel.Row.pricing(text: pricing),
                                ProfileStripeAccountViewModel.Row.spacer(height: 16),
                                ProfileStripeAccountViewModel.Row.simpleInfo(text: LocalizedString.stripeAccountLockedInfo)]),
            ]
        }
                
        items
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.delegate = datasource
    }
}

