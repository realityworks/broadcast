//
//  ProfileStripeAccountViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import UIKit

class ProfileStripeAccountViewController: ViewController {
    private let viewModel = ProfileStripeAccountViewModel()
    
    let tableView = UITableView()
    
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
        tableView.register(ProfileInfoTableViewCell.self,
                           forCellReuseIdentifier: ProfileInfoTableViewCell.identifier)
        
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
        
    }
}

