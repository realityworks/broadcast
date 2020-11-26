//
//  MyPostsViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit
import TinyConstraints

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
    }
    
    private func style() {
        
    }
}

// MARK: - UITableViewDelegate

extension MyPostsViewController : UITableViewDelegate {
    
}


