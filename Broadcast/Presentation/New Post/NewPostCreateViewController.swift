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
    
    #warning("Remove after test confirmation!")
    // MARK: TEST UPLOAD
    let bottomHStackView1 = UIStackView()
    let bottomHStackView2 = UIStackView()
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
        bottomHStackView1.axis = .horizontal
        bottomHStackView1.alignment = .center
        bottomHStackView2.distribution = .fillEqually
        
        bottomHStackView2.axis = .horizontal
        bottomHStackView2.alignment = .center
        bottomHStackView2.distribution = .fillEqually
    }
    
    private func configureLayout() {
        view.addSubview(editPostView)
        view.addSubview(bottomHStackView1)
        view.addSubview(bottomHStackView2)
        
        editPostView.edgesToSuperview(excluding: [.bottom])
        bottomHStackView1.topToBottom(of: editPostView)
        bottomHStackView2.topToBottom(of: bottomHStackView1)
        bottomHStackView2.bottomToSuperview()
        
        bottomHStackView1.leftToSuperview()
        bottomHStackView1.rightToSuperview()
        
        bottomHStackView2.leftToSuperview()
        bottomHStackView2.rightToSuperview()
    }
    
    private func configureBindings() {
        
    }
}
