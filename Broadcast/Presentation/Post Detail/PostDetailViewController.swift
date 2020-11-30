//
//  PostDetailViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation

class PostDetailViewController: ViewController {
    private let viewModel: PostDetailViewModel!
    
    /// Custom required initializer to configure the controller from the specified post ID
    /// - Parameter postID: The Post to view the details of
    init(postID: PostID) {
        viewModel = PostDetailViewModel(postID: postID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not defined, this view controller is not created using a storyboard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
