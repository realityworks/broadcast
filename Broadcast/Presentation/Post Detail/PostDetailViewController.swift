//
//  PostDetailViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit

class PostDetailViewController: ViewController {
    private let viewModel: PostDetailViewModel = PostDetailViewModel()
    
    // MARK: - UI Components
    let deleteButtonContainer = UIView()
    let deleteButton = UIButton.textDestructive(withTitle: LocalizedString.deletePost)
    let activityIndicator = UIActivityIndicatorView()
    
    let scrollView = UIScrollView()
    var postSummaryView = PostSummaryView(withStyling: .detail)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar(styleAs: .dark(title: LocalizedString.post))        

        // Do any additional setup after loading the view.
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    private func configureViews() {
        // Configure the view settings
        postSummaryView.backgroundColor = .white
        deleteButtonContainer.backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.style = .medium
        activityIndicator.color = .primaryBlack
        activityIndicator.hidesWhenStopped = true
    }
    
    private func configureLayout() {
        // Layout the subviews
        view.addSubview(scrollView)
        
        scrollView.edgesToSuperview(usingSafeArea: true)
                               
        scrollView.addSubview(postSummaryView)
        scrollView.addSubview(deleteButtonContainer)
        postSummaryView.topToSuperview()
        postSummaryView.widthToSuperview()
        postSummaryView.addBottomSeparator()
        
        deleteButtonContainer.addTopSeparator()
        deleteButtonContainer.addBottomSeparator()
        deleteButtonContainer.edgesToSuperview(excluding: [.top, .bottom], usingSafeArea: true)
        deleteButtonContainer.height(50)
        deleteButtonContainer.topToBottom(of: postSummaryView, offset: 32)
        deleteButtonContainer.bottomToSuperview(offset: -32)
        
        deleteButtonContainer.addSubview(deleteButton)
        deleteButton.leftToSuperview(offset: 24)
        deleteButton.centerYToSuperview()
        
        deleteButtonContainer.addSubview(activityIndicator)
        activityIndicator.leftToRight(of: deleteButton, offset: 10)
        activityIndicator.centerYToSuperview()
    }
    
    private func configureBindings() {
        viewModel.postSummary
            .subscribe(onNext: { [weak self] summaryViewModel in
                self?.postSummaryView.configure(withPostSummaryViewModel: summaryViewModel)
            })
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showDeleteConfirmation()
            })
            .disposed(by: disposeBag)
        
        viewModel.isDeleting
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.deleteButtonEnabled
            .bind(to: deleteButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.deletedSubject
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func showDeleteConfirmation() {
        let alertController = UIAlertController(title: "Delete Post", message: "This action cannot be undone", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] _ in
            self.viewModel.deletePost()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
