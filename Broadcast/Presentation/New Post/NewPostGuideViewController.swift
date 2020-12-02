//
//  NewPostGuideViewController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 20/11/20.
//

import UIKit
import SwiftRichString

class NewPostGuideViewController: ViewController {
    // MARK: View Model
    private let viewModel = NewPostGuideViewModel()
    
    // MARK: UI Components
    let mainStackView = UIStackView()
    let tipTitleLabel = UILabel()
    
    let detailsStackView = UIStackView()
    let hotTipsTitleLabel = UILabel()
    let doNotShowAgainButton = UIButton()
    let tipsBackgroundView = UIView()
    let tipsList = UIStackView()
    let selectButton = UIButton()
    
    
    struct TipData {
        let icon: UIImage?
        let text: NSAttributedString
    }
    
    let tipsListData: [TipData] = [
        TipData(icon: UIImage(systemName: "paintbrush"),
                text: "Upload or record in ".set(style: Style.title) +
                    "portrait".set(style: Style.titleBold)),
        TipData(icon: UIImage(systemName: "paintbrush"), text: "Keep it snappy".set(style: Style.title)),
        TipData(icon: UIImage(systemName: "paintbrush"), text: "Remember, good sound and lighting!".set(style: Style.title))
    ]
    
    // MARK: UI Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Post"

        // Do any additional setup after loading the view.
        configureViews()
        configureLayout()
        style()
    }
    
    // MARK: UI Configuration
    private func configureViews() {
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.distribution = .equalSpacing
        mainStackView.spacing = 10
        
        detailsStackView.axis = .vertical
        detailsStackView.alignment = .center
        detailsStackView.distribution = .equalSpacing
    }
    
    private func configureLayout() {
        
        // Setup tips layout with stack views
        tipsListData.forEach { tipData in
            let horizontalStackView = UIStackView()
            
            let imageView = UIImageView(image: tipData.icon)
            imageView.contentMode = .scaleAspectFit
            imageView.height(15)
            imageView.width(30)
            
            let label = UILabel()
            label.attributedText = tipData.text
            
            horizontalStackView.addArrangedSubview(imageView)
            horizontalStackView.addArrangedSubview(label)
        }
        
        mainStackView.addArrangedSubview(tipTitleLabel)
        mainStackView.addArrangedSubview(tipsBackgroundView)
        mainStackView.addArrangedSubview(selectButton)
        
        tipsBackgroundView.addSubview(detailsStackView)
        detailsStackView.edgesToSuperview()
        
        view.addSubview(mainStackView)
        mainStackView.edgesToSuperview(excluding: [.bottom], usingSafeArea: true)
    }
    
    private func style() {
        tipsBackgroundView.layer.cornerRadius = 20
        tipsBackgroundView.backgroundColor = .lightGray
        
        tipTitleLabel.attributedText = LocalizedString.newPostTipsTitle.localized.set(style: Style.titleBold)

    }
}

