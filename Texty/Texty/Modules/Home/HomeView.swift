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

    init(presenter: PresenterType, viewModel: HomeViewModel) {
        self.presenter = presenter
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.documentsMetadata, id: \.id) { (document)  in
                    NavigationLink(destination: DocumentDetailView(metaData: document)) {
                        DocumentRowView(metadata: document)
                    }.contextMenu {
                        Button(action: {
                            self.presenter.playAudio(forDocument: document)
                        }) {
                            HStack {
                                Text(NSLocalizedString("Play", comment: "Play audio"))
                                Image(systemName: "play.fill")
                            }
                        }
                        Button(action: {
                            // Delete
                        }) {
                            HStack {
                                Text(NSLocalizedString("Delete", comment: "Delete Document"))
                                Image(systemName: "trash.fill")
                            }
                        }
                    }
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
