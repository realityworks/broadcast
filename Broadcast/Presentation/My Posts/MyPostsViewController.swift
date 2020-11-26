//
//  MyPostsViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit

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
        
    }
    
    private func configureLayout() {
        
    }
    
    private func configureBindings() {
        // Setup the table view
    }
    
    private func style() {
        
    }
}


