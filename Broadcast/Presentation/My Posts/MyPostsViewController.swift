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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "My Posts"
        
        configureViews()
        configureBindings()
        style()
        
        #warning("Need to move this on account finished loading...")
        viewModel.refreshMyPostsList()
    }
    
    private func configureViews() {
        // Configure view parameters
        tableView.register(MyPostsTableViewCell.self,
                           forCellReuseIdentifier: MyPostsTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        
        // Layout the views
        view.addSubview(tableView)
        tableView.edgesToSuperview()

    }
        
    private func configureBindings() {        
        // Setup the table view
        viewModel.myPostsObservable
            .bind(to: tableView.rx.items(cellIdentifier: MyPostsTableViewCell.identifier, cellType: MyPostsTableViewCell.self)) { _, model, cell in
                Logger.log(level: .verbose, topic: .debug, message: "Init cell : \(model.title)")
                cell.configure(withViewModel: model)
            }
            .disposed(by: disposeBag)
        
        let titleLabel = UILabel.largeTitle(.myPostsHeading)
        let titleHeaderView = UIView()
        
        titleHeaderView.addSubview(titleLabel)
        titleLabel.edgesToSuperview(excluding: [.left, .right])
        titleLabel.leftToSuperview(offset: 20)
        titleLabel.rightToSuperview(offset: -20)
        
        titleHeaderView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        tableView.tableHeaderView = titleHeaderView
        
        tableView.rx.modelSelected(MyPostsCellViewModel.self)
            .observeOn(Schedulers.standard.main)
            .subscribe(onNext: { model in
                self.viewModel.selectPost(with: model.postId)
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedSubject
            .subscribe(onNext: { _ in
                self.navigationController?.push(with: .postDetail)
            })
            .disposed(by: disposeBag)
    }
    
    private func style() {
        
    }
}
