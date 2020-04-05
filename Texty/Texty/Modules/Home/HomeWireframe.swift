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
    private let moduleDelegate: HomeDelegate?

    init(delegate: HomeDelegate?) {
        self.moduleDelegate = delegate
    }

    var view: some View {
        let cameraInteractor = CameraDocumentInteractor(delegate: nil)
        let persistenceInteractor = PersistenceInteractor()
        let presenter = HomePresenter(delegate: moduleDelegate, cameraInteractor: cameraInteractor, persistenceInteractor: persistenceInteractor)
        cameraInteractor.delegate = presenter
        let view = HomeView(presenter: presenter, viewModel: presenter.createViewModel())
        return view
    }
}
