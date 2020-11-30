//
//  PostDetailViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import Foundation

class PostDetailViewController: ViewController {
    private let viewModel: PostDetailViewModel
    
    required init(postID: PostID) {
        viewModel.configure(withPost)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not defined, this view controller is not created using a storyboard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
