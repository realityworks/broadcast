//
//  MyPostsSection.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/11/20.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

struct MyPostsSection {
    var items: [MyPostCellViewModel]
}

extension MyPostsSection : SectionModelType {
    typealias Item = MyPostCellViewModel
    
    init(original: MyPostsSection, items: [MyPostCellViewModel]) {
        self = original
        self.items = items
    }
}
