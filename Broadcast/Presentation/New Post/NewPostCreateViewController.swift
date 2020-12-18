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
    let progressView = UIProgressView()
        
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
        
        view.addSubview(progressView)
        progressView.topToBottom(of: editPostView.verticalStackView)
        progressView.width(150)
        progressView.height(25)
    }
    
    private func configureBindings() {
        editPostView.uploadButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.uploadPost()
            })
            .disposed(by: disposeBag)
        
        viewModel.title
            .bind(to: editPostView.titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.caption
            .bind(to: editPostView.captionTextView.rx.text)
            .disposed(by: disposeBag)
    }
}
