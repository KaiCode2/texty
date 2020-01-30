//
//  RootCoordinator.swift
//  Texty
//
//  Created by Kai Aldag on 2020-01-29.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import UIKit

internal protocol DismissableDelegate {
    func didRequestDismissal()
}

internal final class RootCoordinator {
    fileprivate var navigationController: UINavigationController
    fileprivate let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.navigationController.navigationBar.isHidden = true
        self.window.rootViewController = navigationController
    }

    func start() {
        navigateToHome()
    }
}

private extension RootCoordinator {
    func navigateToHome() {
        let homeVC = HomeViewController(delegate: self)
        navigationController.pushViewController(homeVC, animated: false)
    }
}

extension RootCoordinator: HomeDelegate {

}

extension RootCoordinator: DismissableDelegate {
    func didRequestDismissal() {
        navigationController.popViewController(animated: true)
    }
}
