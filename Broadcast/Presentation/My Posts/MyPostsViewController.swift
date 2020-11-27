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

class MyPostsViewController: ViewController {
    
    private let viewModel = MyPostsViewModel()
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
        // Setup the table view
        viewModel.myPostsObservable
            .bind(to: tableView.rx.items(cellIdentifier: MyPostTableViewCell.identifier, cellType: MyPostTableViewCell.self)) { _, model, cell in
                Logger.log(level: .verbose, topic: .debug, message: "Init cell : \(model.title)")
                cell.configure(withViewModel: model)
            }
            .disposed(by: disposeBag)
    }
    
    private func style() {
        
    }
}

// MARK: - UITableViewDelegate

extension MyPostsViewController : UITableViewDelegate {
    
}


