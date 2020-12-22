//
//  NewPostCreateViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 8/12/20.
//

import UIKit
import RxSwift
import RxCocoa


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
        progressView.topToBottom(of: editPostView.uploadButton, offset: 20)
        progressView.centerXToSuperview()
        progressView.width(150)
        progressView.height(25)
    }
    
    private func configureBindings() {
        editPostView.uploadButton.rx.tap
            .subscribe(onNext: { _ in
                self.viewModel.uploadPost()
            })
            .disposed(by: disposeBag)
        
        editPostView.titleTextField.rx.controlEvent(.editingChanged)
            .map { [unowned self] in self.editPostView.titleTextField.text ?? "" }
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)
                
        editPostView.captionTextView.rx.text
            .compactMap { $0 }
            .bind(to: viewModel.caption)
            .disposed(by: disposeBag)
                
        viewModel.progress
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        viewModel.isUploading
            .map { !$0 }
            .bind(to: editPostView.uploadButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
