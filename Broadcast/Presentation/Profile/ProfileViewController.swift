//
//  ProfileViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit

class ProfileViewController: ViewController {
    private let viewModel = ProfileViewModel()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Profile"
        
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    private func configureViews() {
        tableView.register(ProfileTableViewCell.Self, forCellReuseIdentifier: ProfileTableCellView.identifier)
    }
    
    private func configureLayout() {
        
    }
    
    private func configureBindings() {
        
    }
    
}
