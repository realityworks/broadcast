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
    let commentStackView = UIStackView()
    
    let lockerImageView = UIImageView()
    let lockerCountLabel = UILabel()
    let lockerStackView = UIStackView()
    
    let horizontalStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        commentImageView.contentMode = .scaleAspectFit
        commentImageView.image = UIImage(systemName: "bubble.right")?.withRenderingMode(.alwaysTemplate)
        commentImageView.tintColor = .black
        
        commentImageView.aspectRatio(1)
        
        lockerImageView.contentMode = .scaleAspectFit
        lockerImageView.image = UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysTemplate)
        lockerImageView.tintColor = .black
        
        lockerImageView.aspectRatio(1)
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.alignment = .fill
    }
    
    private func layoutViews() {
        addSubview(horizontalStackView)
        
        commentStackView.addArrangedSubview(commentImageView)
        commentStackView.addSpace(2)
        commentStackView.addArrangedSubview(commentCountLabel)
        
        lockerStackView.addArrangedSubview(lockerImageView)
        lockerStackView.addSpace(2)
        lockerStackView.addArrangedSubview(lockerCountLabel)
        
        horizontalStackView.edgesToSuperview(excluding: [.left, .right])
        horizontalStackView.width(177)
        
        horizontalStackView.addArrangedSubview(commentStackView)
        horizontalStackView.addArrangedSubview(lockerStackView)
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
