//
//  Document.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-03.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI
import Foundation

struct Document: Identifiable {
    var id: UUID

    struct Page {
        let pageNumber: Int?
        let pageContent: String
        let images: [CGImage]?

//        let lines: [String]
    }
    struct DocumentMetaData {
        let title: String?
        let author: String?
        let releaseDate: NSDate?
        let pageCount: Int?

        var coverImage: Image! {
            didSet(newValue) {
                if newValue == nil {
                    if let pageCount = pageCount {
                        let isMultiplePages = pageCount > 1
                        self.coverImage = isMultiplePages ? Image(systemName: "book") : Image(systemName: "doc")
                    } else {
                        self.coverImage = Image(systemName: "doc")
                    }
                }
            }
        }

        static func empty() -> DocumentMetaData {
            return DocumentMetaData(title: nil, author: nil, releaseDate: nil, pageCount: nil, coverImage: nil)
        }
    }
    var pages: [Page]
    let metaData: DocumentMetaData

    init(pages: [Page], metaData: DocumentMetaData, id: UUID = UUID()) {
        self.pages = pages
        self.metaData = metaData
        self.id = id
    }

    var aggragatedText: String {
        return self.pages.reduce("") { (aggregatedText, nextPage) -> String in
            return aggregatedText + " " + nextPage.pageContent
        }
    }

    mutating func add(pageString: String, number: Int? = nil) {
        pages.append(Document.Page(pageNumber: number, pageContent: pageString, images: nil))
    }
}
