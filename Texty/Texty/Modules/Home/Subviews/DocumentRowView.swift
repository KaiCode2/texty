//
//  DocumentRowView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-18.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI

struct DocumentRowView: View {
    private var documentMetadata: Binding<Document.MetaData>

    init(metadata: Binding<Document.MetaData>) {
        self.documentMetadata = metadata
    }

    var body: some View {
        HStack(spacing: 20) {
            (documentMetadata.coverImage.wrappedValue != nil ? Image(uiImage: documentMetadata.coverImage.wrappedValue!) : Image(systemName: "doc"))
                .resizable(capInsets: EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5),
                           resizingMode: .stretch)
                .frame(width: 30, height: 30)



            VStack (alignment: .leading) {
                Text(!documentMetadata.title.wrappedValue.isEmpty ? documentMetadata.title.wrappedValue : "Untitled Document")
                    .font(.title)
                Text(DateFormatter.localizedString(from: documentMetadata.releaseDate.wrappedValue,
                                                   dateStyle: .medium,
                                                   timeStyle: .short))
                    .font(.subheadline)
            }
        }
    }
}
