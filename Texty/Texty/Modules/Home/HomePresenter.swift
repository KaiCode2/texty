//
//  HomePresenter.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-05.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import VisionKit
import SwiftUI
import AVFoundation

protocol HomeViewSupplierType {
    func scanView() -> DocumentScannerView
}

protocol HomePresenterType: ObservableObject {
    var documents: [Document] { get set }
}

internal class HomePresenter: HomePresenterType, HomeViewSupplierType {
    private let moduleDelegate: HomeDelegate

    private let cameraInteractor: CameraDocumentInteractor

    @Published var documents: [Document] = []

    var view: HomeView? = nil


    init(delegate: HomeDelegate, cameraInteractor: CameraDocumentInteractor) {
        self.moduleDelegate = delegate
        self.cameraInteractor = cameraInteractor

    }

    func scanView() -> DocumentScannerView {
        let scanner = DocumentScannerView(interactor: cameraInteractor)
        return scanner
    }
}

extension HomePresenter: CameraDocumentInteractorDelegate {
    func didFinish(withDocument document: Document) {
        documents.append(document)
        let utterance = AVSpeechUtterance(string: document.aggragatedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.6

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }


}


