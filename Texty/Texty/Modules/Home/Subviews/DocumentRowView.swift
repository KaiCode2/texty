//
//  DocumentRowView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-18.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI

struct DocumentRowView: View {
    private var documentMetadata: Document.MetaData

    init(metadata: Document.MetaData) {
        self.documentMetadata = metadata
    }

    var body: some View {
        HStack {
            (documentMetadata.coverImage != nil ? Image(uiImage: documentMetadata.coverImage!) : Image(systemName: "doc"))
                .resizable()
                .frame(width: 50, height: 50)
            VStack {
                Text(documentMetadata.title ?? "Untitled Document")
                Text(DateFormatter.localizedString(from: documentMetadata.releaseDate ?? Date(),
                                                   dateStyle: .medium,
                                                   timeStyle: .short))
            }

            Spacer()
        }
    }
}
