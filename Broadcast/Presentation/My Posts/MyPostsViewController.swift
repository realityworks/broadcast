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
        
        configureViews()
        configureLayout()
        configureBindings()
        style()
    }
    
    private func configureViews() {
        tableView.delegate = self
        //tableView.datasource = self
    }
    
    private func configureLayout() {
        tableView.edgesToSuperview()
    }
    
    private func configureBindings() {
        // Setup the table view

        viewModel.myPostsObservable
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, element: String) in
                let cell = MyPostTableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = element
                return cell
            }
            .disposed(by: disposeBag)
            
    }
    
    private func style() {
        
    }
}

// MARK: - UITableViewDelegate

extension MyPostsViewController : UITableViewDelegate {
    
}


