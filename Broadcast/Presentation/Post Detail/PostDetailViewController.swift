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
    let postSummaryView = PostSummaryView()
    let postCaptionLabel = UILabel()
    
    /// Custom required initializer to configure the controller from the specified post ID
    /// - Parameter postID: The Post to view the details of
    init(isEditing: Bool) {
        viewModel.enableEdit(isEditing)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not defined, this view controller is not created using a storyboard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViews()
        configureBindings()
        style()
    }
    
    private func configureViews() {
        // Configure the view settings
        view.addSubview(verticalStackView)
        
        
        
        // Layout the subviews
        verticalStackView.addArrangedSubview(postSummaryView)
        verticalStackView.addArrangedSubview(postCaptionLabel)
        
    }
    
    private func configureBindings() {
        viewModel.postSummary
            .subscribe(onNext: { [weak self] summaryViewModel in
                self?.postSummaryView.configure(
                    withTitle: summaryViewModel.title,
                    thumbnailURL: summaryViewModel.thumbnailURL,
                    commentCount: summaryViewModel.commentCount,
                    lockerCount: summaryViewModel.lockerCount,
                    dateCreated: summaryViewModel.dateCreated,
                    isEncoding: summaryViewModel.isEncoding)
            })
            .disposed(by: disposeBag)
        
        viewModel.postCaption
            .bind(to: postCaptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func style() {
        
    }
}
