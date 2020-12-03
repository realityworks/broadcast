//
//  UINavigationController.swift
//  Broadcast
//
//  Created by Piotr Suwara on 19/11/20.
//

import UIKit

extension UINavigationController {
    func push(with route: Route) {
        guard let viewController = route.viewControllerInstance() else { return }
        self.pushViewController(viewController, animated: true)
    }
}
