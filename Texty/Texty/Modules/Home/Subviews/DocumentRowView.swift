//
//  DocumentRowView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-18.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI

struct DocumentRowView: View {
    var document: Document

    var body: some View {
        HStack {
//            (document.metaData?.coverImage ?? Image(systemName: "doc"))
//                .resizable()
//                .frame(width: CGFloat(50), height: CGFloat(50), alignment: .leading)
//            Text(document.metaData?.title)
            Text("hello world")
            Spacer()
        }
    }
}
