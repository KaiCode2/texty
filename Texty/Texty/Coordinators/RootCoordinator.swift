//
//  RootCoordinator.swift
//  Texty
//
//  Created by Kai Aldag on 2020-01-29.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import UIKit
import SwiftUI

internal protocol DismissableDelegate {
    func didRequestDismissal()
}

internal final class RootCoordinator {
    fileprivate let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let view = HomeWireframe(delegate: self).view
        window.rootViewController = UIHostingController(rootView: view)
    }
}

private extension RootCoordinator {
    func navigateToHome() {
        
    }
}

extension RootCoordinator: HomeDelegate {
    func didRequestLibraryScan() {

    }

    func didRequestCameraScan() {
        
    }
}

extension RootCoordinator: DismissableDelegate {
    func didRequestDismissal() {

    }
}
