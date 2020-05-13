//
//  DocumentDetailView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-18.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI
import Combine

struct DocumentDetailView: View {
    private var document: Binding<Document>

    @State fileprivate var verticalOffset: CGFloat = 0

    init(document: Binding<Document>) {
        self.document = document
    }

    private var header: DocumentHeaderView {
        let header = DocumentHeaderView(image: document.metaData.coverImage.wrappedValue)
        return header
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    header
                        .offset(y: verticalOffset)
                    CirclePlayView()
                        .frame(width: 80, height: 80)
                        .offset(x: 0, y: -35 + verticalOffset)

                    HStack(alignment: .top, spacing: 5) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(document.metaData.author.wrappedValue ?? "Untitled Author")
                            Text("\(DateFormatter.localizedString(from: document.metaData.releaseDate.wrappedValue, dateStyle: .medium, timeStyle: .none))")
                        }.padding(.leading, 10)
                        Spacer(minLength: 35)
                        VStack(alignment: .trailing, spacing: 5) {
                            Text("PAGE# / \(document.metaData.pageCount.wrappedValue)")
                            Text("Time Remaining")
                        }.padding(.trailing, 10)
                    }.offset(x: 0, y: -75 + verticalOffset)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Pages").font(.headline)
                        PagesContentView(pages: document.pages)
                        
                    }
                }
            }.offset(x: 0, y: -50)
        }
        .navigationBarTitle(Text(document.metaData.title.wrappedValue ?? "Untitled Document"))
        .navigationBarItems(trailing: Button(action: {
            print("edit mode")
        }, label: {
            return Text("Edit")
        }))

//            .onReceive(header.showingPublisher) { (isShowing) in
//                if isShowing {
//                    self.verticalOffset += 200
//                } else {
//                    self.verticalOffset -= 200
//                }
//        }
    }


    static func cameraView(_ image: UIImage?) -> AnyView {
        if let image = image {
            return AnyView(Image(uiImage: image).resizable())
        } else {
            return AnyView(Image(systemName: "camera").aspectRatio(1, contentMode: .fit))
        }
    }
}

#if DEBUG

var document = Document(pages: [
    Document.Page(pageNumber: 1, pageContent: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", image: nil),
    Document.Page(pageNumber: 2, pageContent: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", image: nil),
    Document.Page(pageNumber: 3, pageContent: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.", image: nil)
], metaData: Document.MetaData(id: UUID(), title: "Test Document", releaseDate: Date(), pageCount: 1))


var testDoc: Binding<Document> {
    return Binding(get: {
        return document
    }) { (newDocument) in
        document = newDocument
    }
}

struct DocumentDetailView_Previews: PreviewProvider {


    static var previews: some View {
        DocumentDetailView(document: testDoc)
    }
}
#endif
