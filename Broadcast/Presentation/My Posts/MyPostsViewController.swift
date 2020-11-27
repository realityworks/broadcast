//
//  MyPostsViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit
import TinyConstraints
import RxSwift
import RxCocoa
import RxDataSources

class MyPostsViewController: ViewController {
    
    private let viewModel = MyPostsViewModel()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "My Posts"
        
        configureLayout()
        configureViews()
        configureBindings()
        style()
        
        #warning("Need to move this on account finished loading...")
        viewModel.refreshMyPostsList()
    }
    
    private func configureViews() {
        tableView.register(MyPostTableViewCell.self,
                           forCellReuseIdentifier: MyPostTableViewCell.identifier)
        
        tableView.separatorStyle = .none
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
    
    private func configureBindings() {        
        // Setup the table view
        viewModel.myPostsObservable
            .bind(to: tableView.rx.items(cellIdentifier: MyPostTableViewCell.identifier, cellType: MyPostTableViewCell.self)) { _, model, cell in
                Logger.log(level: .verbose, topic: .debug, message: "Init cell : \(model.title)")
                cell.configure(withViewModel: model)
            }
            .disposed(by: disposeBag)
        
        let titleLabel = UILabel.largeTitle(.myPostsHeading)
        let titleHeaderView = UIView()
        
        titleHeaderView.addSubview(titleLabel)
        titleLabel.edgesToSuperview(excluding: [.left, .right])
        titleLabel.leftToSuperview(offset: 20)
        titleLabel.rightToSuperview(offset: -20)
        
        titleHeaderView.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        tableView.tableHeaderView = titleHeaderView
    }
    
    private func style() {
        
    }
}

//// MARK: - UITableViewDelegate
//
//extension MyPostsViewController : UITableViewDelegate {
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UILabel.largeTitle(LocalizedString.myPostsHeading)
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 200
//    }
//}


