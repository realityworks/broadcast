//
//  PostStatsView.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit

class PostStatsView : UIView {
    let commentImageView = UIImageView()
    let commentCountLabel = UILabel()
    let lockerImageView = UIImageView()
    let lockerCountLabel = UILabel()
    let horizontalStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .fill
    }
    
    private func layoutViews() {
        addSubview(horizontalStackView)
        horizontalStackView.height(40)
        
        horizontalStackView.addArrangedSubview(commentImageView)
        horizontalStackView.addArrangedSubview(commentCountLabel)
        horizontalStackView.addArrangedSubview(lockerImageView)
        horizontalStackView.addArrangedSubview(lockerCountLabel)
    }
    
    /// Configure the view content with view model data
    /// - Parameters:
    ///   - commentCount: Number of comments
    ///   - lockerCount: Number of lockers this post is in
    func configure(withCommentCount commentCount: Int, lockerCount: Int) {
        commentCountLabel.text = "\(commentCount)"
        lockerCountLabel.text = "\(lockerCount)"
    }
}
