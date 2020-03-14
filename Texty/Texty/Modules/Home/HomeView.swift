//
//  HomeView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-16.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI

internal struct HomeView: View {
    typealias PresenterType = HomePresenter //Any<HomePresenterType, HomeViewSupplier>
    private var viewPresenter: HomeViewSupplierType

    @State var viewModel: HomeViewModel
    
    @State fileprivate var isShowingScan = false

    init(presenter: PresenterType) {
        self.viewPresenter = presenter
        self._viewModel = State(wrappedValue: presenter.createViewModel())
    }

    var body: some View {
        NavigationView {
            List (self.viewModel.documentsMetadata) { document in
                NavigationLink(destination: DocumentDetailView(document: document)) {
                    DocumentRowView(metadata: document)
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
            return self.viewPresenter.scanView()
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
