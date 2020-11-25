//
//  Route.swift
//  Broadcast
//
//  Created by Piotr Suwara on 18/11/20.
//

import UIKit

indirect enum Route {
    case none
    case login
    case main(child: Route)
    case myPosts
    case profile
}

extension Route {
    func viewControllerInstance() -> UIViewController? {
        switch self {
        case .none:
            return nil
        case .login:
            return LoginViewController()
        case .main(let child):
            let mainViewController = MainViewController()
            mainViewController.selectRoute(child)
            return mainViewController
        case .myPosts:
            return MyPostsViewController()
        case .profile:
            return ProfileViewController()
        }
    }
}
