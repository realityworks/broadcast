//
//  Route.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit

indirect enum Route {
    case login
    case mainScreen(child: Route)
}

extension Route {
    func viewControllerInstance() -> UIViewController {
        switch self {
        case .login:
            return LoginViewController()
        case .mainScreen(let child):
            return MainViewController()
        }
    }
}
