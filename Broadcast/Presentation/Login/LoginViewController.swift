//
//  LoginViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit
import TinyConstraints
import RxCocoa
import RxSwift

class LoginViewController: ViewController {
    private let viewModel = LoginViewModel()
    
    // MARK: UI Components
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let logoImage = UIImage()
    private let loginButton = UIButton()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureComponents()
        configureBindings()
        style()
    }
    
    /// Setup the UI component layout
    private func configureComponents() {
        
        view.addSubview(scrollView)
        scrollView.edgesToSuperview()
        
        scrollView.addSubview(contentStackView)
    }
    
    /// Configure the bindings between the view model and
    private func configureBindings() {
        
    }
    
    /// Style the user interface and components
    private func style() {
        
    }
}

