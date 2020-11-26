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
    
    let postView = PostView()
    
    #warning("TODO")
    //let processingView =
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Setup the view
        self.addSubview(thumbnailImageView)
        self.addSubview(postTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
