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
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    // MARK: UI Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar(styleAs: .darkLogo)
        
        configureViews()
        configureLayout()
        configureBindings()
        style()
        
        #warning("Need to move this on account finished loading...")
        viewModel.refreshMyPostsList()
    }
    
    private func configureViews() {
        /// Register the cells used in the tableview
        tableView.register(MyPostsTableViewCell.self,
                           forCellReuseIdentifier: MyPostsTableViewCell.identifier)
        
        tableView.separatorStyle = .none

        /// Configure pull to refresh
        tableView.refreshControl = refreshControl
    }
    
    private func configureLayout() {
        /// Layout the views
        view.addSubview(tableView)
        tableView.edgesToSuperview()

        
        /// Configure the table view header
        let titleLabel = UILabel.largeTitle(.myPostsHeading)
        let titleHeaderView = UIView()

        titleHeaderView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        tableView.tableHeaderView = titleHeaderView

        titleHeaderView.addSubview(titleLabel)
        titleLabel.edgesToSuperview(excluding: [.left, .right])
        titleLabel.leftToSuperview(offset: 20)
    }
        
    private func configureBindings() {        
        // Setup the table view
        viewModel.myPostsObservable
            .bind(to: tableView.rx.items(cellIdentifier: MyPostsTableViewCell.identifier, cellType: MyPostsTableViewCell.self)) { _, model, cell in
                Logger.log(level: .verbose, topic: .debug, message: "Init cell : \(model.title)")
                cell.configure(withViewModel: model)
            }
            .disposed(by: disposeBag)
        
        /// Notify the view model when a cell is tapped
        tableView.rx.modelSelected(MyPostsCellViewModel.self)
            .subscribe(onNext: { model in
                self.viewModel.selectPost(with: model.postId)
            })
            .disposed(by: disposeBag)
        
        /// Handle the selected subject of the tapped cell, go into the post detail
        viewModel.selectedSubject
            .subscribe(onNext: { _ in
                self.navigationController?.push(with: .postDetail)
            })
            .disposed(by: disposeBag)
        
        /// Bind the refresh control to load posts lists
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                self.viewModel.refreshMyPostsList()
            })
            .disposed(by: disposeBag)
        
        viewModel.newPostsLoadedSignal
            .subscribe(onNext: {
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    private func style() {
        
    }
    
    
}
