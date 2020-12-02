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
    let titleLabel = UILabel()
    
    let detailsStackView = UIStackView()
    let hotTipsLabel = UILabel()
    
    struct TipData {
        let icon: UIImage
        let text: NSAttributedString
    }
    
    var tipsList: UIStackView!
    
    private static let boldStyle = Style {
        $0.font = SystemFonts.Helvetica_Bold.font(size: 15)
    }
    
    private static let normalStyle = Style {
        $0.font = SystemFonts.Helvetica_Bold.font(size: 15)
    }
    
    let tipsListData: [TipData] = [
        TipData(icon: UIImage(systemName: "paintbrush"), text: <#T##NSAttributedString#>)
    ]
    
    // MARK: UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

