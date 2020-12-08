//
//  NewPostCreateViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 8/12/20.
//

import UIKit


class NewPostCreateViewController : ViewController, KeyboardEventsAdapter {
    var dismissKeyboardGestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer()
    
    private let viewModel = NewPostCreateViewModel()
    
    // MARK: UI Components
    let editPostView = EditPostView()
        
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
        view.addSubview(editPostView)
        editPostView.edgesToSuperview()
    }
    
    private func configureBindings() {
        
    }
}
