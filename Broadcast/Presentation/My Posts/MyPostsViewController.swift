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
import Lottie
import SwiftRichString

class MyPostsViewController: ViewController {
    
    private let viewModel = MyPostsViewModel()
    
    private let tableView = UITableView()
    private let ghostLoadingAnimationView = AnimationView(animationAsset: .myPostsGhostLoad)
    private let refreshControl = UIRefreshControl()
    
    private let titleLabel = UIImageView(image: UIImage.logoBoomdayBroadcaster?.withTintColor(.primaryLightGrey))
    private let titleHeaderView = UIView()
    
    // No posts background view
    private let noPostsStackView = UIStackView()
    private let noPostsTitleView = UILabel.text(LocalizedString.noPosts,
                                                font: UIFont.boldTableTitle,
                                                textColor: .tertiaryLightGrey)
    private let noPostsDetailLabel = UILabel()

    
    // MARK: UI Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureLayout()
        configureBindings()
        
        viewModel.refreshMyPostsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after loading the view.
        navigationBar(styleAs: .dark(title: LocalizedString.myPostsHeading))
    }
    
    private func configureViews() {        
        /// Register the cells used in the tableview
        tableView.register(MyPostsTableViewCell.self,
                           forCellReuseIdentifier: MyPostsTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        /// Configure pull to refresh
        tableView.refreshControl = refreshControl
        
        let createPostButton = UIBarButtonItem(image: UIImage.iconPlusSquare,
                                               style: UIBarButtonItem.Style.plain,
                                               target: self,
                                               action: #selector(createPostTapped))
        createPostButton.tintColor = .white
        navigationItem.rightBarButtonItem = createPostButton
        
        ghostLoadingAnimationView.loopMode = .loop
        ghostLoadingAnimationView.backgroundBehavior = .pauseAndRestore
        
        // Setup the no posts view
        noPostsStackView.axis = .vertical
        noPostsStackView.alignment = .center
        noPostsStackView.spacing = 24
        
        let noPostDetailStyle = Style {
            $0.font = UIFont.largeBodyMedium
            $0.color = UIColor.tertiaryLightGrey
        }
        
        let localImage = AttributedString(image: UIImage.iconPlusSquare?.withTintColor(.tertiaryLightGrey))
        
        noPostsDetailLabel.attributedText =
            "TAP ".set(style: noPostDetailStyle) +
            (localImage ?? AttributedString()) +
            " TO ADD A NEW POST".set(style: noPostDetailStyle)
    }
    
    private func configureLayout() {
        
        /// Layout the views
        view.addSubview(tableView)
        tableView.edgesToSuperview()

        /// Configure the table view header (Will be changed)
        titleHeaderView.frame = CGRect(x: 0, y: 0, width: 200, height: 96)
        tableView.tableHeaderView = titleHeaderView
        titleHeaderView.width(to: view)
        titleHeaderView.height(96)

        titleHeaderView.addSubview(titleLabel)
        titleLabel.centerInSuperview()
        
        view.addSubview(noPostsStackView)
        noPostsStackView.centerXToSuperview()
        noPostsStackView.centerYToSuperview(offset: -16)
        
        noPostsStackView.addArrangedSubview(noPostsTitleView)
        noPostsStackView.addArrangedSubview(noPostsDetailLabel)
        
        view.addSubview(ghostLoadingAnimationView)
        ghostLoadingAnimationView.topToSuperview(offset: 96)
        ghostLoadingAnimationView.leadingToSuperview(offset: 24)
        ghostLoadingAnimationView.trailingToSuperview(offset: 24)
        ghostLoadingAnimationView.height(550)
        ghostLoadingAnimationView.contentMode = .scaleToFill
        ghostLoadingAnimationView.play()
    }
        
    private func configureBindings() {        
        // Setup the table view
        viewModel.myPostsObservable
            .bind(to: tableView.rx.items(cellIdentifier: MyPostsTableViewCell.identifier, cellType: MyPostsTableViewCell.self)) { _, model, cell in
                Logger.log(level: .verbose, topic: .debug, message: "Init cell : \(model.title)")
                cell.selectionStyle = .none
                cell.configure(withViewModel: model)
            }
            .disposed(by: disposeBag)
        
        /// Notify the view model when a cell is tapped
        tableView.rx.modelSelected(MyPostsCellViewModel.self)
            .subscribe(onNext: { model in
                self.viewModel.selectPost(with: model.postId)
            })
            .disposed(by: disposeBag)
        
        /// Handle the selected subject of the tapped cell, go into the post detail
        viewModel.selectedSubject
            .subscribe(onNext: { _ in
                self.navigationController?.push(with: .postDetail)
            })
            .disposed(by: disposeBag)
        
        /// Bind the refresh control to load posts lists
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                self.viewModel.refreshMyPostsList()
            })
            .disposed(by: disposeBag)
        
        viewModel.newPostsLoadedSignal
            .subscribe(onNext: {
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        viewModel.createPostSignal
            .subscribe(onNext: { [self] _ in
                navigationController?.push(with: .newPostCreate)
            })
            .disposed(by: disposeBag)

        viewModel.isLoadingPostsFirstTimeObservable
            .map { !$0 }
            .bind(to: ghostLoadingAnimationView.rx.isHidden)
            .disposed(by: disposeBag)
        
        /// Need this to stop major performance impact
        viewModel.isLoadingPostsFirstTimeObservable
            .delay(.milliseconds(1000), scheduler: Schedulers.standard.utility)
            .subscribe( onNext: { isLoadingFirstTime in
                if !isLoadingFirstTime {
                    self.ghostLoadingAnimationView.stop()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isPostListEmptyObservable
            .map { !$0 } // Negate
            .bind(to: noPostsStackView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    @objc func createPostTapped() {
        viewModel.createPost()
    }
}
