//
//  DocumentDetailView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-18.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI

struct DocumentDetailView: View {
    private var metaData: Document.MetaData


    init(metaData: Document.MetaData) {
        self.metaData = metaData
    }

    var body: some View {
        VStack {
            Text(metaData.title ?? "Untitled Document")


//            ForEach (document.pages, id: \.self) { page in
//                Text(page.pageContent)
//            }
        }
    }
}

//struct DocumentDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentDetailView()
//    }
//}
