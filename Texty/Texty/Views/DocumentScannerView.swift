//
//  DocumentScannerView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-17.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI
import VisionKit


internal struct DocumentScannerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = VNDocumentCameraViewController

//    private let delegate: CameraDocumentInteractorDelegate
    private var interactor: CameraDocumentInteractor

    init(interactor: CameraDocumentInteractor) {
//        self.delegate = delegate
        self.interactor = interactor
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = interactor
        return viewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<DocumentScannerView>) {}
}
