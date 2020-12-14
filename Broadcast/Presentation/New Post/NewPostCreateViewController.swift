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
    
    #warning("Remove!")
    // MARK: TEST UPLOAD
    let bottomHStackView = UIStackView()
    let createPostIdButton = UIButton.standard(withTitle: "CREATE")
    let requestUploadUrlButton = UIButton.standard(withTitle: "REQ URL")
    let uploadFileButton = UIButton.standard(withTitle: "UPLOAD")
    let completeFileUploadButton = UIButton.standard(withTitle: "COMPLETE")
    let updateContentButton = UIButton.standard(withTitle: "UPDATE")
    let publishButton = UIButton.standard(withTitle: "PUBLISH")
        
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
