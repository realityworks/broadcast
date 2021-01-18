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
    //let verticalStackView = UIStackView()
    let deleteButtonContainer = UIView()
    let deleteButton = UIButton.textDestructive(withTitle: LocalizedString.deletePost)
    let activityIndicator = UIActivityIndicatorView()
    
    let scrollView = UIScrollView()
    var postSummaryView: PostSummaryView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar(styleAs: .dark(title: LocalizedString.post))        
        postSummaryView = PostSummaryView(withStyling: .detail)

        // Do any additional setup after loading the view.
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    private func configureViews() {
        // Configure the view settings
        postSummaryView.backgroundColor = .white
        deleteButtonContainer.backgroundColor = .clear
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.style = .medium
        activityIndicator.color = .primaryBlack
        activityIndicator.hidesWhenStopped = true
    }
    
    private func configureLayout() {
        // Layout the subviews
        view.addSubview(scrollView)
        view.addSubview(deleteButtonContainer)
        
        scrollView.edgesToSuperview(excluding: [.bottom], usingSafeArea: true)
        scrollView.bottomToTop(of: deleteButtonContainer)
                
        deleteButtonContainer.edgesToSuperview(excluding: [.top, .bottom], usingSafeArea: true)
        deleteButtonContainer.bottomToSuperview(usingSafeArea: true)
        deleteButtonContainer.height(60)
               
        scrollView.addSubview(postSummaryView)
        postSummaryView.topToSuperview()
        postSummaryView.bottomToSuperview()
        postSummaryView.widthToSuperview()
        
        deleteButtonContainer.addSubview(deleteButton)
        deleteButton.centerInSuperview()
        
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
            .subscribe(onNext: { _ in
                self.viewModel.deletePost()
            })
            .disposed(by: disposeBag)
        
        viewModel.isDeleting
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.deleteButtonEnabled
            .bind(to: deleteButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.deletedSubject
            .subscribe(onNext: { _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
