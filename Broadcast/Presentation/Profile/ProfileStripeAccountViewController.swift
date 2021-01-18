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
        
        tableView.register(ProfileSectionHeaderCell.self,
                           forCellReuseIdentifier: ProfileSectionHeaderCell.identifier)
        
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
    
    private func configureBindings() {
        let datasource = ReactiveTableViewModelSource<ProfileStripeAccountSectionModel>(configureCell: { _, tableView, indexPath, row -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextFieldTableViewCell.identifier, for: indexPath) as! ProfileTextFieldTableViewCell
            
            let titleText: String
            let detailText: String
            
            switch row {
            case let .productId(text):
                titleText = LocalizedString.id.localized
                detailText = text
            case let .pricing(text):
                titleText = LocalizedString.pricing.localized
                detailText = text
            case let .totalBalance(text):
                titleText = LocalizedString.totalBalance.localized
                detailText = text
            case let .lifetimeTotalVolume(text):
                titleText = LocalizedString.lifetimeTotalVolume.localized
                detailText = text
            }
            
            cell.configure(withTitle: titleText,
                           text: detailText,
                           editingEnabled: false,
                           showLockIcon: false)
            return cell
        })

        datasource.heightForRowAtIndexPath = { _, indexPath -> CGFloat in
            AccountInfoTableViewCell.cellHeight
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
        
        let items = Observable.combineLatest(
            viewModel.productIdObseravable,
            viewModel.pricingObservable,
            viewModel.totalBalanceObservable,
            viewModel.lifetimeTotalVolumeObservable) {
            
            productId, pricing, _, _ -> [ProfileStripeAccountSectionModel] in
            
            return [
                SectionModel(model: LocalizedString.id, items: [
                                ProfileStripeAccountViewModel.Row.productId(text: productId)]),
                SectionModel(model: LocalizedString.pricing, items: [
                                ProfileStripeAccountViewModel.Row.pricing(text: pricing)])
            ]
        }
                
        items
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.delegate = datasource
    }
}

