//
//  UIViewController+Routing.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit

extension UIViewController {
    func present(with route: Route) {
        guard let viewController = route.viewControllerInstance() else { return }
        self.present(viewController, animated: false) {
            // TODO
        } //
    }
}
