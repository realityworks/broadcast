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
    private let logoImageView = UIImageView()
    
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let errorDispayView = DismissableLabel()
    private let loginButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureLayout()
        configureBindings()
        style()
    }
    
    /// Setup the UI component layout
    private func configureLayout() {
        
        view.addSubview(scrollView)
        scrollView.edgesToSuperview()
        
        scrollView.addSubview(contentStackView)
        contentStackView.addSubview(logoImageView)
        contentStackView.addSpace(height: 100)
        contentStackView.addSubview(usernameTextField)
        contentStackView.addSubview(passwordTextField)
        contentStackView.addSubview(passwordTextField)
        
    }
    
    /// Configure the bindings between the view model and
    private func configureBindings() {
        
    }
    
    /// Style the user interface and components
    private func style() {
        
    }
}

