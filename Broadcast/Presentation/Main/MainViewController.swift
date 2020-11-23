//
//  MainViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/11/20.
//

import UIKit

class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleView()
    }
    
    func styleView() {
        view.backgroundColor = .white
    }
}
