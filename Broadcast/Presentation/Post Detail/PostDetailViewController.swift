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
        view.backgroundColor = UIColor.secondaryWhite
        postSummaryView.backgroundColor = .white
        deleteButtonContainer.backgroundColor = .clear
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        // Configure the view settings
        //verticalStackView.axis = .vertical
        //verticalStackView.distribution = .equalSpacing
    }
    
    private func configureLayout() {
        // Layout the subviews
//        view.addSubview(verticalStackView)
//        verticalStackView.addArrangedSubview(postSummaryView)
//        verticalStackView.addSpace(40)
//        verticalStackView.addArrangedSubview(deleteButton)
//
//        verticalStackView.edgesToSuperview(excluding: [.bottom], usingSafeArea: true)
        
        view.addSubview(scrollView)
        view.addSubview(deleteButtonContainer)
        
        scrollView.edgesToSuperview(excluding: [.bottom], usingSafeArea: true)
        scrollView.bottomToTop(of: deleteButtonContainer)
                
        deleteButtonContainer.edgesToSuperview(excluding: [.top, .bottom], usingSafeArea: true)
        deleteButtonContainer.bottomToSuperview(usingSafeArea: true)
        deleteButtonContainer.height(80)
               
        scrollView.addSubview(postSummaryView)
        postSummaryView.topToSuperview()
        postSummaryView.bottomToSuperview()
        postSummaryView.widthToSuperview()
        
        deleteButtonContainer.addSubview(deleteButton)
        deleteButton.centerInSuperview()
    }
    
    private func configureBindings() {
        viewModel.postSummary
            .subscribe(onNext: { [weak self] summaryViewModel in
                self?.postSummaryView.configure(withPostSummaryViewModel: summaryViewModel)
            })
            .disposed(by: disposeBag)
    }
}
