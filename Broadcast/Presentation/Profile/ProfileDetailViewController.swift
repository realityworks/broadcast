//
//  ProfileDetailViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 3/12/20.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileDetailViewController: ViewController {
    private let viewModel = ProfileDetailViewModel()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Profile Detail"
    }
}

