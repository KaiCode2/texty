//
//  HomeWireframe.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-05.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI

protocol HomeDelegate {
    func didRequestCameraScan()
    func didRequestLibraryScan()
}

internal final class HomeWireframe {
    private let moduleDelegate: HomeDelegate

    init(delegate: HomeDelegate) {
        self.moduleDelegate = delegate
    }

    var view: HomeView {
        let cameraInteractor = CameraDocumentInteractor(delegate: nil)
        var presenter = HomePresenter(delegate: moduleDelegate, cameraInteractor: cameraInteractor)
        cameraInteractor.delegate = presenter
        let view = HomeView(presenter: presenter)
        presenter.view = view
        return view
    }
}
