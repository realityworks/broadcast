//
//  MyPostTableViewCell.swift
//  Broadcast
//
//  Created by Piotr Suwara on 26/11/20.
//

import UIKit
import SDWebImage

class MyPostTableViewCell : UITableViewCell {
    static let identifier = "MyPostTableViewCell"
    
    let postSummaryView = PostSummaryView()
        
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
        styleView()
    }
    
    func configureView() {
        contentView.addSubview(postSummaryView)
        postSummaryView.edgesToSuperview()
    }
    
    func styleView() {
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withViewModel viewModel: MyPostCellViewModel) {
        postSummaryView.configure(
            withTitle: viewModel.title,
            thumbnailURL: viewModel.thumbnailURL,
            commentCount: viewModel.commentCount,
            lockerCount: viewModel.lockerCount,
            dateCreated: viewModel.dateCreated,
            isEncoding: viewModel.isEncoding)
    }
}
