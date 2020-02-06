//
//  HomeWireframe.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-05.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import Foundation

protocol HomeDelegate {
    func didRequestCameraScan()
    func didRequestLibraryScan()
}

internal final class HomeWireframe {
    private let moduleDelegate: HomeDelegate

    init(delegate: HomeDelegate) {
        self.moduleDelegate = delegate
    }

    var viewController: HomeViewController {
        let presenter = HomePresenter(delegate: moduleDelegate)
        return HomeViewController(presenter: presenter)
    }
}
