//
//  HomeViewModel.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-25.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @ObservedObject private var presenter: HomePresenter

    @State var documentsMetadata: [Document.MetaData] {
        willSet (newValue) {
            print(newValue)
        }
    }

    private var assigner: AnyCancellable!


    init(presenter: HomePresenter) {
        self.presenter = presenter
        self.documentsMetadata = []

        assigner = Publishers.Map(upstream: presenter.didChange) { (documents) -> [Document.MetaData] in
            return documents.map { (document) -> Document.MetaData in
                return document.metaData
            }
        }.receive(on: RunLoop.main).assign(to: \.documentsMetadata, on: self)
    }
}
