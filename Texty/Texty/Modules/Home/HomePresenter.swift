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
import Combine

protocol HomeViewSupplierType {
    func createViewModel() -> HomeViewModel
    func scanView() -> DocumentScannerView
}

protocol HomePresenterType: ObservableObject {
    func setAddDocumentCompletion(completion: @escaping (Document) -> Void)
}

internal class HomePresenter: HomePresenterType, HomeViewSupplierType {

    private let moduleDelegate: HomeDelegate

    private let cameraInteractor: CameraDocumentInteractor

    var didChange = PassthroughSubject<[Document], Never>()
    private var documents: [Document] {
        willSet (newValue) {
            didChange.send(newValue)
        }
    }
    private var addedDocumentsCompletion: ((Document) -> Void)? = nil


    init(delegate: HomeDelegate, cameraInteractor: CameraDocumentInteractor) {
        self.moduleDelegate = delegate
        self.cameraInteractor = cameraInteractor
        documents = []
    }

    func setAddDocumentCompletion(completion: @escaping (Document) -> Void) {
        addedDocumentsCompletion = completion
    }

    func createViewModel() -> HomeViewModel {
        let viewModel = HomeViewModel(presenter: self)
        return viewModel
    }

    func scanView() -> DocumentScannerView {
        let scanner = DocumentScannerView(interactor: cameraInteractor)
        return scanner
    }
}

extension HomePresenter: CameraDocumentInteractorDelegate {
    func didFinish(withDocument document: Document) {
        documents.append(document)
        addedDocumentsCompletion?(document)
        let utterance = AVSpeechUtterance(string: document.aggragatedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.6

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}


