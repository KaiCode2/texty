//
//  HomeView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-16.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI

internal struct HomeView: View {
    private let presenter: HomePresenterType

    @State var isShowingScan = false

    init(presenter: HomePresenterType) {
        self.presenter = presenter
    }

//    @State var model: HomePresenter.Model

     var body: some View {
        Button(action: {
            self.isShowingScan = true
        }) {
            return Text("Add")
        }.sheet(isPresented: self.$isShowingScan) { () -> DocumentScannerView in
            return self.presenter.scanView()
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
