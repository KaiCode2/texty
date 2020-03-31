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

protocol HomePresenterType {
    func loadDocuments()
    func document(fromMetaData metaData: Document.MetaData) -> Document
    func playAudio(forDocument document: Document.MetaData)
    func deleteDocument(document: Document.MetaData)
}

protocol HomeControllerType: HomeViewSupplierType, HomePresenterType { }

internal class HomePresenter: HomeControllerType, ObservableObject {

    private let moduleDelegate: HomeDelegate

    private let cameraInteractor: CameraDocumentInteractor
    private var persistenceInteractor: PersistenceInteractor

    var didChange = PassthroughSubject<[Document], Never>()
    private var documents: [Document] {
        willSet (newValue) {
            didChange.send(newValue)
        }
    }


    init(delegate: HomeDelegate,
         cameraInteractor: CameraDocumentInteractor,
         persistenceInteractor: PersistenceInteractor) {
        self.moduleDelegate = delegate
        self.cameraInteractor = cameraInteractor
        self.persistenceInteractor = persistenceInteractor

        documents = []
    }

    func loadDocuments() {
        persistenceInteractor.loadDocumentMetadatas { [weak self] (metas) in
            self?.documents = metas.map { Document(pages: [], metaData: $0) }
        }
    }

    func document(fromMetaData metaData: Document.MetaData) -> Document {

//        persistenceInteractor.loadDocumentPages(forDocument: metaData) { (pages) in
//            print(pages)
//        }

        return Document(pages: [], metaData: metaData)
    }

    func playAudio(forDocument document: Document.MetaData) {
        print("Unimplmented")
    }

    func deleteDocument(document: Document.MetaData) {
        print("Unimplmented")
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

        persistenceInteractor.save(document: document)

        let utterance = AVSpeechUtterance(string: document.aggragatedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.6

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}


