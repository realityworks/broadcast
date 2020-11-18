//
//  UIViewController+Routing.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit

extension UIViewController {
    func present(with route: Route) {
        self.present(route.viewControllerInstance(), animated: false) {
            // TODO
        } //
    }
}
