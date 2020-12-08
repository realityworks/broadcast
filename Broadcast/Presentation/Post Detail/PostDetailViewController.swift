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
    var postSummaryView: PostSummaryView!
    let postCaptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postSummaryView = PostSummaryView(withStyling: .detail)

        // Do any additional setup after loading the view.
        configureViews()
        configureBindings()
        style()
    }
    
    private func configureViews() {
        // Configure the view settings
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .equalSpacing
        
        postCaptionLabel.font = .body
        postCaptionLabel.numberOfLines = 0
        
        // Layout the subviews
        view.addSubview(verticalStackView)
        view.addSubview(postCaptionLabel)
        
        verticalStackView.addArrangedSubview(postSummaryView)
        
        verticalStackView.edgesToSuperview(excluding: [.bottom], usingSafeArea: true)
        
        postCaptionLabel.topToBottom(of: verticalStackView)
        postCaptionLabel.leftToSuperview(offset: 20)
        postCaptionLabel.rightToSuperview()
    }
    
    private func configureBindings() {
        viewModel.postSummary
            .subscribe(onNext: { [weak self] summaryViewModel in
                self?.postSummaryView.configure(withPostSummaryViewModel: summaryViewModel)
            })
            .disposed(by: disposeBag)
        
        viewModel.postCaption
            .bind(to: postCaptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func style() {
        view.backgroundColor = .white
    }
}
