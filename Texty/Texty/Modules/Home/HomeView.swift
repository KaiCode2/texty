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

    @ObservedObject var viewModel: HomeViewModel<PresenterType>
    @State fileprivate var isShowingScan = false

    init(presenter: PresenterType) {
        self.viewPresenter = presenter
        viewModel = HomeViewModel<PresenterType>(presenter: presenter)
    }

//    init<PresentType: HomePresenterType>(viewSupplier: HomeViewSupplierType, presenter: PresentType){
//
//    }

    var body: some View {
        NavigationView {
            List(self.viewModel.documents) { document in
                NavigationLink(destination: DocumentDetailView(document: document)) {
                    DocumentRowView(document: document)
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

extension HomeView {
    class HomeViewModel<PresenterType: HomePresenterType>: ObservableObject {
        @ObservedObject private var presenter: PresenterType

        @Published private(set) var documents: [Document] = []

        init(presenter: PresenterType) {
            self.presenter = presenter
            documents = presenter.$documents
//            presenter.objectWillChange.subscribe(presenter.documents)
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
