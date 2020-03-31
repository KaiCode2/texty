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
                    NavigationLink(destination: DocumentDetailView(document: document)) {
                        DocumentRowView(metadata: document)
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Documents", comment: "Documents")))
            .navigationBarItems(trailing: Button(action: {
                self.isShowingScan = true
            }) {
                return Image(systemName: "plus.circle")
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
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//       HomeView(presenter: HomePresenter(delegate: RootCoordinator(window: UIWindow())))
//    }
//}
#endif
