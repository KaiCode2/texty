//
//  Page.swift
//  Texty
//
//  Created by Kai Aldag on 2020-05-12.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI
import TextyKit

struct Page: View {
    let page: Document.Page

    init(page: Document.Page) {
        self.page = page
    }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(Constants.Text.indent + page.pageContent)
                .foregroundColor(Color(white: 0.8))
                .allowsTightening(true)
            .minimumScaleFactor(0.7)
//                .scaledToFill()
//                .fixedSize(horizontal: true, vertical: true)
//            .aspectRatio(5/9, contentMode: .fill)
//            Spacer(minLength: 15)
            Text("\(page.pageNumber)").bold().foregroundColor(Color(white: 0.9))
            .minimumScaleFactor(0.8)
        }
        .padding(.all, 10)
        .background(Color(white: 0.1))
        .cornerRadius(8)
        .aspectRatio(6/9, contentMode: .fit)
        .shadow(radius: 2)
        .colorScheme(.light)
    }
}

struct Page_Previews: PreviewProvider {
    static var previews: some View {
        Page(page: Document.Page(pageNumber: 1, pageContent: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", image: nil))
    }
}
