//
//  NewPostCreateViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 8/12/20.
//

import UIKit


class NewPostCreateViewController : ViewController {
    private let viewModel = NewPostCreateViewModel()
    
    let verticalStackView = UIStackView()
    let titleTextField = UITextField()
    let captionTextView = UITextView()
    let uploadButton = UIButton()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    private func configureViews() {
        
    }
    
    private func configureLayout() {
        
    }
    
    private func configureBindings() {
        
    }
}
