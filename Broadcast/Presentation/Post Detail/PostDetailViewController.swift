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
    let verticalStackView = UIStackView()
    let deleteButton = UIButton.textDestructive(withTitle: LocalizedString.deletePost)
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
        
        // Configure the view settings
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
    }
    
    private func configureLayout() {
        // Layout the subviews
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(postSummaryView)
        
        verticalStackView.edgesToSuperview(excluding: [.bottom], usingSafeArea: true)
    }
    
    private func configureBindings() {
        viewModel.postSummary
            .subscribe(onNext: { [weak self] summaryViewModel in
                self?.postSummaryView.configure(withPostSummaryViewModel: summaryViewModel)
            })
            .disposed(by: disposeBag)
    }
}
