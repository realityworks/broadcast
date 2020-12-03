//
//  ProfileViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class ProfileViewController: ViewController {
    private let viewModel = ProfileViewModel()
    
    typealias Datasource = ReactiveTableViewModelSource<SectionModel<String?, ProfileViewModel.Row>>
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Profile"
        
        configureViews()
        configureLayout()
        configureBindings()
    }
    
    private func configureViews() {
        tableView.register(ProfileTableViewCell.self,
                           forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
    }
    
    private func configureLayout() {
        
    }
    
    private func configureBindings() {
        let datasource = Datasource(configureCell: { _, tableView, indexPath, row -> UITableViewCell in
            switch row {
            case detail:
                let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as! ProfileTableViewCell
                cell.configure(title: icon:)
                return cell
            case subscription:
            case frequentlyAskedQuestions:
            case privacyPolicy:
            case termsAndConditions:
            case share:
            case logout:
                
            }
        }))
    }
    
}
