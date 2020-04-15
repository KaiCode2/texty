//
//  HomeView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-16.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI

internal struct HomeView: View {
    typealias PresenterType = HomeControllerType //Any<HomePresenterType, HomeViewSupplier>
//    private var viewPresenter: HomeViewSupplierType
    private var presenter: PresenterType

    @ObservedObject var viewModel: HomeViewModel
    
    @State fileprivate var isShowingScan = false
    @State fileprivate var userSelectedDeleteDocument: Document.MetaData? = nil

    init(presenter: PresenterType, viewModel: HomeViewModel) {
        self.presenter = presenter
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.documentsMetadata, id: \.id) { (document)  in
                    NavigationLink(destination: DocumentDetailView(document: self.presenter.document(fromMetaData: document))) {
                        DocumentRowView(metadata: document)
                        .contextMenu {
                            Button(action: {
                                self.presenter.playAudio(forDocument: document)
                            }) {
                                HStack {
                                    Text(NSLocalizedString("Play", comment: "Play audio"))
                                    Image(systemName: "play.fill")
                                }
                            }
                            Button(action: {
                                self.userSelectedDeleteDocument = document
                            }) {
                                HStack {
                                    Text(NSLocalizedString("Delete", comment: "Delete Document"))
                                    Image(systemName: "trash.fill")
                                }
                            }
                        }
                    }
                }
                .onDelete { (indexSet) in
                    guard let index = indexSet.first,
                        index < self.viewModel.documentsMetadata.count,
                        indexSet.count == 1 else {
                            return
                    }
                    self.userSelectedDeleteDocument = self.viewModel.documentsMetadata[index]
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Documents", comment: "Documents")))
            .navigationBarItems(trailing: Button(action: {
                self.isShowingScan = true
            }) {
                return Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
            })
        }
        .alert(item: $userSelectedDeleteDocument, content: { (document) -> Alert in
            Alert(title: Text("Are you sure you want to delete this document? This action cannot be reversed."),
                  primaryButton: Alert.Button.destructive(Text("Delete"), action: {
                    self.presenter.deleteDocument(document: document)
                  }),
                  secondaryButton: Alert.Button.cancel())
        })
        .sheet(isPresented: self.$isShowingScan) { () -> DocumentScannerView in
            return self.presenter.scanView()
        }
        .onAppear {
            self.presenter.loadDocuments()
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {

    static var previews: some View {
        // TODO: add injected view models
        HomeWireframe(delegate: nil).view
    }
}
#endif
