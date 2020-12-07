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

    }
    
    private func configureLayout() {
        
    }
    
    private func configureBindings() {
        
    }
}

