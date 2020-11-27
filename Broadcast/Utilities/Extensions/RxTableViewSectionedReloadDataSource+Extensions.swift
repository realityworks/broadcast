//
//  RxTableViewSectionedReloadDataSource+Extensions.swift
//  Broadcast
//
//  Created by Piotr Suwara on 27/11/20.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ReactiveTableViewModelSource<S: SectionModelType>: RxTableViewSectionedReloadDataSource<S>, UITableViewDelegate {
    typealias HeightForCellAtIndexPath = (TableViewSectionedDataSource<S>, IndexPath) -> CGFloat

    typealias ViewForHeaderInSection = (TableViewSectionedDataSource<S>, UITableView, Int) -> UIView?
    typealias HeightForHeaderInSection = (TableViewSectionedDataSource<S>, Int) -> CGFloat

    typealias ViewForFooterInSection = (TableViewSectionedDataSource<S>, UITableView, Int) -> UIView?
    typealias HeightForFooterInSection = (TableViewSectionedDataSource<S>, Int) -> CGFloat

    var heightForRowAtIndexPath: HeightForCellAtIndexPath = { _, _ in UITableView.automaticDimension }

    var viewForHeaderInSection: ViewForHeaderInSection = { _, _, _ in nil }
    var heightForHeaderInSection: HeightForHeaderInSection = { _, _ in 0 }

    var viewForFooterInSection: ViewForFooterInSection = { _, _, _ in nil }
    var heightForFooterInSection: HeightForFooterInSection = { _, _ in 0 }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderInSection(self, tableView, section)
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderInSection(self, section)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooterInSection(self, tableView, section)
    }

    func tableView(_: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInSection(self, section)
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAtIndexPath(self, indexPath)
    }
}
