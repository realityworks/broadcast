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
import SwiftRichString

class LoginViewController: ViewController, KeyboardEventsAdapter {
    var dismissKeyboardGestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer()
    
    private let viewModel = LoginViewModel()
    
    // MARK: UI Components
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let bottomStackView = UIStackView()
    private let logoImageView = UIImageView(image: UIImage.boomdayLogo?.withRenderingMode(.alwaysTemplate))
    private let broadcasterImageView = UIImageView(image: .broadcasterLogo)
    private let activityIndicator = UIActivityIndicatorView()
    
    private let usernameTextField = LoginTextField.username(
        withPlaceholder: LocalizedString.usernamePlaceholder)
    
    private let passwordTextField = LoginTextField.password(
        withPlaceholder: LocalizedString.passwordPlaceholder)
    
    private let loginButton = UIButton.standard(
        withTitle: LocalizedString.loginButton)
    
    private let welcomeLabel = UILabel.largeTitle(LocalizedString.welcome)
    private let applyHereTextView = UITextView()
    private let forgotPasswordTextView = UITextView()
    
    private let errorPopup = ErrorPopup()
    
    // MARK: Test Items
    
    private let testUserName: String = "Angela84@hotmail.com"
    private let testPassword: String = "Pass123$"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViews()
        configureLayout()
        configureBindings()
        style()
        registerForKeyboardEvents()
    }
    
    /// Setup the UI component layout
    private func configureViews() {
        view.addGestureRecognizer(dismissKeyboardGestureRecognizer)
        dismissKeyboardGestureRecognizer.addTarget(self, action: #selector(dismissKeyboard))
        
        logoImageView.tintColor = .primaryBlack
        logoImageView.contentMode = .scaleAspectFit
        
        activityIndicator.style = .medium
        activityIndicator.color = .primaryBlack
        
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.distribution = .equalSpacing
        
        applyHereTextView.isScrollEnabled = false
        forgotPasswordTextView.isScrollEnabled = false
        forgotPasswordTextView.textAlignment = .left
        
        let usernameIcon = UIImageView(image: UIImage.iconProfile?.withRenderingMode(.alwaysTemplate))
        usernameIcon.contentMode = .scaleAspectFit
        usernameIcon.tintColor = .lightGray
        usernameTextField.leftView = usernameIcon
        usernameTextField.leftViewMode = .always
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.font = .body
        
        let passwordIcon = UIImageView(image: UIImage.iconLock?.withRenderingMode(.alwaysTemplate))
        passwordIcon.contentMode = .scaleAspectFit
        passwordIcon.tintColor = .lightGray
        passwordTextField.leftView = passwordIcon
        passwordTextField.leftViewMode = .always
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.font = .body
        
        activityIndicator.hidesWhenStopped = true
        
        if Configuration.debugUIEnabled {
            usernameTextField.text = testUserName
            passwordTextField.text = testPassword
            viewModel.username.accept(testUserName)
            viewModel.password.accept(testPassword)
        }
    }
    
    private func configureLayout() {
        view.addSubview(scrollView)
        
        /// Setup scroll view
        scrollView.edgesToSuperview(insets: TinyEdgeInsets(top: 0, left: 24, bottom: 0, right: 24), usingSafeArea: true)
        scrollView.addSubview(contentStackView)
        
        /// Setup content stack view
        contentStackView.topToSuperview()
        contentStackView.widthToSuperview()
        contentStackView.addArrangedSubview(logoImageView)
        
        /// Add arranged views to stack
        contentStackView.addSpace(117)
        contentStackView.addArrangedSubview(logoImageView)
        contentStackView.addSpace(13)
        contentStackView.addArrangedSubview(broadcasterImageView)
        contentStackView.addSpace(38)
        contentStackView.addArrangedSubview(welcomeLabel)
        contentStackView.addSpace(10)
        contentStackView.addArrangedSubview(usernameTextField)
        contentStackView.addSpace(22)
        contentStackView.addArrangedSubview(passwordTextField)
        contentStackView.addSpace(4)
        contentStackView.addArrangedSubview(forgotPasswordTextView)
        contentStackView.addSpace(36)
        contentStackView.addArrangedSubview(loginButton)
        //contentStackView.addSpace(56)
        let activityIndicatorContainerView = UIView()
        contentStackView.addArrangedSubview(activityIndicatorContainerView)
        contentStackView.addArrangedSubview(applyHereTextView)
        
        activityIndicatorContainerView.addSubview(activityIndicator)
        //activityIndicatorContainerView.centerInSuperview()
        activityIndicatorContainerView.height(56)
        activityIndicatorContainerView.width(56)
        activityIndicator.edgesToSuperview()
        
        logoImageView.height(38)
        broadcasterImageView.height(28)
        
        /// Configure insets of arranged sub views
        let textFields = [usernameTextField, passwordTextField]
        textFields.forEach {
            $0.widthToSuperview()
        }
        
        loginButton.widthToSuperview()
        
        /// Configure the text views
        welcomeLabel.height(50)
        applyHereTextView.height(30)
        applyHereTextView.leftToSuperview()
        applyHereTextView.rightToSuperview()
        
        forgotPasswordTextView.leftToSuperview()
        forgotPasswordTextView.rightToSuperview()
        
        forgotPasswordTextView.height(30)
    }
    
    /// Configure the bindings between the view model and
    private func configureBindings() {
        
        usernameTextField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: { [unowned self] _ in
                self.passwordTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: { [unowned self] _ in
                self.passwordTextField.resignFirstResponder()
                self.viewModel.login()
            })
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.dismissKeyboard()
                self.viewModel.login()
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoginEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameTextField.rx.controlEvent(.editingChanged)
            .map { [unowned self] in self.usernameTextField.text }
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(.editingChanged)
            .map { [unowned self] in self.passwordTextField.text }
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .map { !$0 }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    /// Style the user interface and components
    private func style() {
        view.backgroundColor = .white
        
        // Style attributed strings
        let boomdayLinkStyle = Style {
            $0.font = UIFont.body
            $0.underline = (.single, UIColor.primaryGrey)
            $0.linkURL = URL(string: "https://boomday.com")
            $0.alignment = .center
        }
        
        applyHereTextView.attributedText =
            "\(LocalizedString.notABroadcaster.localized) ".set(style: Style.bodyCenter) +
            LocalizedString.learnMore.localized.set(style: boomdayLinkStyle)
        
        let forgotPasswordStyle = Style {
            $0.font = UIFont.smallBody
            $0.alignment = .left
            $0.linkURL = URL(string: "https://boomday.com")
        }
        
        forgotPasswordTextView.attributedText = LocalizedString
            .forgotPassword
            .localized
            .set(style: forgotPasswordStyle)
        
        // Style the text views
        let textViews = [applyHereTextView,
                         forgotPasswordTextView]
        
        textViews.forEach { $0.tintColor = .primaryGrey }
        
        // Setup the left view for the login/password views
        
    }
    
    @objc func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

