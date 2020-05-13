//
//  PagesContentView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-05-12.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI

struct PagesContentView: View {
    let pages: Binding<[Document.Page]>

    init(pages: Binding<[Document.Page]>) {
        self.pages = pages
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 5) {
                ForEach(pages.wrappedValue, id: \.id) { page in
                    Page(page: page)
                }
            }.padding(.all, 10)
        }
    }
}

#if DEBUG

var pages = [
Document.Page(pageNumber: 1, pageContent: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", image: nil),
     Document.Page(pageNumber: 2, pageContent: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", image: nil),
          Document.Page(pageNumber: 3, pageContent: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", image: nil)
]

struct PagesContentView_Previews: PreviewProvider {
    static var previews: some View {
        PagesContentView(pages: Binding(get: {
            return pages
        }, set: { pages = $0 }))
    }
}

#endif
