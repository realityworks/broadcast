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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .fill
        
        horizontalStackView.addArrangedSubview(commentImageView)
        horizontalStackView.addArrangedSubview(commentCountLabel)
        horizontalStackView.addArrangedSubview(lockerImageView)
        horizontalStackView.addArrangedSubview(lockerCountLabel)
    }
    
    func configure(withCommentCount commentCount: Int, lockerCount: Int) {
        commentCountLabel.text = "\(commentCount)"
        lockerCountLabel.text = "\(lockerCount)"
    }
}
