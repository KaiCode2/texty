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
    func document(fromMetaData metaData: Document.MetaData) -> Binding<Document>
    func playAudio(forDocument document: Document.MetaData)
    func deleteDocument(document: Document.MetaData)
}

protocol HomeControllerType: HomeViewSupplierType, HomePresenterType { }

internal class HomePresenter: HomeControllerType, ObservableObject {
    private let moduleDelegate: HomeDelegate?

    private let cameraInteractor: CameraDocumentInteractor
    private var persistenceInteractor: PersistenceInteractor

    var didChange = PassthroughSubject<[Document], Never>()
    private var documents: [Document] {
        willSet (newValue) {
            didChange.send(newValue)
        }
    }


    init(delegate: HomeDelegate?,
         cameraInteractor: CameraDocumentInteractor,
         persistenceInteractor: PersistenceInteractor) {
        self.moduleDelegate = delegate
        self.cameraInteractor = cameraInteractor
        self.persistenceInteractor = persistenceInteractor

        documents = []
    }

    func loadDocuments() {
        do {
            self.documents = try persistenceInteractor.loadDocuments()
        } catch let error  {
            print(error)
        }
    }

    func document(fromMetaData metaData: Document.MetaData) -> Binding<Document> {

        guard let document = documents.enumerated().filter({ return $0.1.id == metaData.id }).first else {
            fatalError()
        }

        if document.element.isPagesLoaded {
            return Binding(get: {
                return self.documents[document.offset]
            }) { newValue in
                self.documents[document.offset] = newValue
            }
        } else {
            do {
                let pages = try persistenceInteractor.loadDocumentPages(forDocument: metaData)
                documents[document.offset].pages = pages
                return Binding(get: {
                    return self.documents[document.offset]
                }) { newValue in
                    self.documents[document.offset] = newValue
                }
            } catch {
                fatalError()
            }
        }
    }

    func playAudio(forDocument document: Document.MetaData) {
        print("Unimplmented")
    }

    func deleteDocument(document: Document.MetaData) {
        do {
            try persistenceInteractor.deleteDocument(document: document)
            documents.removeAll(where: { return $0.id == document.id })
        } catch let error {

        }
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

        do { try persistenceInteractor.save(document: document) }
        catch let error { print(error) }

        let utterance = AVSpeechUtterance(string: document.aggragatedText)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.6

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}


