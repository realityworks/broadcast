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
        
        configureViews()
        configureLayout()
        configureBindings()
        
        viewModel.refreshMyPostsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        navigationBar(styleAs: .darkLogo)
    }
    
    private func configureViews() {
        view.backgroundColor = UIColor.secondaryWhite
        
        /// Register the cells used in the tableview
        tableView.register(MyPostsTableViewCell.self,
                           forCellReuseIdentifier: MyPostsTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        /// Configure pull to refresh
        tableView.refreshControl = refreshControl
        
        let createPostButton = UIBarButtonItem(image: UIImage.iconPlusCircle,
                                               style: UIBarButtonItem.Style.plain,
                                               target: self,
                                               action: #selector(createPostTapped))
        createPostButton.tintColor = .white
        navigationItem.rightBarButtonItem = createPostButton
    }
    
    private func configureLayout() {
        /// Layout the views
        view.addSubview(tableView)
        tableView.edgesToSuperview()

        /// Configure the table view header (Will be changed)
        #warning("This will change - Move title label to properties")
        let titleLabel = UILabel.text(.myPostsHeading,
                                      font: .tableTitle,
                                      textColor: .primaryLightGrey)
        let titleHeaderView = UIView()

        titleHeaderView.frame = CGRect(x: 0, y: 0, width: 200, height: 96)
        tableView.tableHeaderView = titleHeaderView

        titleHeaderView.addSubview(titleLabel)
        titleLabel.edgesToSuperview(excluding: [.left, .right])
        titleLabel.leftToSuperview(offset: 22)
    }
        
    private func configureBindings() {        
        // Setup the table view
        viewModel.myPostsObservable
            .bind(to: tableView.rx.items(cellIdentifier: MyPostsTableViewCell.identifier, cellType: MyPostsTableViewCell.self)) { _, model, cell in
                Logger.log(level: .verbose, topic: .debug, message: "Init cell : \(model.title)")
                cell.selectionStyle = .none
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
        
        viewModel.createPostSignal
            .subscribe(onNext: { [self] _ in
                navigationController?.push(with: .newPostCreate)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func createPostTapped() {
        viewModel.createPost()
    }
}
