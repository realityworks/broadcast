//
//  MyPostsViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit
import TinyConstraints
import RxSwift
import RxCocoa
import RxDataSources

class MyPostsViewController: ViewController {
    
    private let viewModel = MyPostsViewModel()
    
    var dataSource: RxTableViewSectionedReloadDataSource<MyPostsSection>!
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "My Posts"
        
        configureLayout()
        configureViews()
        configureBindings()
        style()
        
        #warning("Need to move this on account finished loading...")
        viewModel.refreshMyPostsList()
    }
    
    private func configureViews() {
        tableView.register(MyPostTableViewCell.self, forCellReuseIdentifier: MyPostTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
    
    private func configureBindings() {
        // Setup the datasource
        dataSource = RxTableViewSectionedReloadDataSource<MyPostsSection>(
            configureCell: { (_, tableView, indexPath, viewModel) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: MyPostTableViewCell.identifier, for: indexPath) as! MyPostTableViewCell
                cell.configure(withViewModel: viewModel)
                return cell
            })
        
        // Setup the table view
        viewModel.myPostsObservable
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: DisposeBag())
    }
    
    private func style() {
        
    }
}

// MARK: - UITableViewDelegate

extension MyPostsViewController : UITableViewDelegate {
    
}


