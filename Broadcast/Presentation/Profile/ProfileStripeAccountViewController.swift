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
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Stripe Account"
        
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    
    private func configureViews() {
        // Configure Views
        tableView.register(AccountInfoTableViewCell.self,
                           forCellReuseIdentifier: AccountInfoTableViewCell.identifier)
        
        tableView.register(ProfileSectionHeaderCell.self,
                           forCellReuseIdentifier: ProfileSectionHeaderCell.identifier)
        
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountInfoTableViewCell.identifier, for: indexPath) as! AccountInfoTableViewCell
            
            let cellDetailText: String
            switch row {
            
            case let .name(text):
                cellDetailText = text
            case let .identifier(text):
                cellDetailText = text
            case let .pricing(text):
                cellDetailText = text
            case let .payments(text):
                cellDetailText = text
            case let .payouts(text):
                cellDetailText = text
            case let .totalBalance(text):
                cellDetailText = text
            case let .lifetimeTotalVolume(text):
                cellDetailText = text
            }
            
            cell.configure(withTitle: cellDetailText)
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
            viewModel.nameObservable,
            viewModel.identifierObservable,
            viewModel.pricingObservable,
            viewModel.paymentsObservable,
            viewModel.payoutsObservable,
            viewModel.totalBalanceObservable,
            viewModel.lifetimeTotalVolumeObservable) {
            
            name, identifier, pricing, payments, payouts, totalBalance, lifetimeTotalVolume -> [ProfileStripeAccountSectionModel] in
            
            return [
                SectionModel(model: LocalizedString.name, items: [
                                ProfileStripeAccountViewModel.Row.name(text: name)]),
                SectionModel(model: LocalizedString.id, items: [
                                ProfileStripeAccountViewModel.Row.identifier(text: identifier)]),
                SectionModel(model: LocalizedString.pricing, items: [
                                ProfileStripeAccountViewModel.Row.pricing(text: name)]),
                SectionModel(model: LocalizedString.payments, items: [
                                ProfileStripeAccountViewModel.Row.payments(text: name)]),
                SectionModel(model: LocalizedString.payouts, items: [
                                ProfileStripeAccountViewModel.Row.payouts(text: name)]),
                SectionModel(model: LocalizedString.totalBalance, items: [
                                ProfileStripeAccountViewModel.Row.totalBalance(text: name)]),
                SectionModel(model: LocalizedString.lifetimeTotalVolume, items: [
                                ProfileStripeAccountViewModel.Row.lifetimeTotalVolume(text: name)]),
            ]
        }
                
        items
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: disposeBag)
        
        tableView.delegate = datasource
    }
}

