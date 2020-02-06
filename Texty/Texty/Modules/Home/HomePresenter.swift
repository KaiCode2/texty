//
//  HomePresenter.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-05.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import Foundation

internal final class HomePresenter {
    private let moduleDelegate: HomeDelegate

    init(delegate: HomeDelegate) {
        self.moduleDelegate = delegate
    }
}
