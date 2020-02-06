//
//  Document.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-03.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import UIKit

struct Document {
    struct Page {
        let pageNumber: Int?
        let pageContent: String
        let images: [CGImage]?
    }
    struct DocumentMetaData {
        let title: String
        let author: String
        let releaseDate: NSDate
        let pageCount: Int
    }
    var pages: [Page]
    let metaData: DocumentMetaData?

    var aggragatedText: String {
//        self.pages.reduce("") { (aggregatedText, nexLine) -> String in
//            if nexLine.last == "-" {
//                self.document.add(pageString: nexLine)
//            } else {
//                self.document.add(pageString: line + " ")
//            }
//            if nexLine.pageContenten
//            aggregatedText + " " + nextPage.pageContent
//        }
        return "hello world"
    }

    mutating func add(pageString: String, number: Int? = nil) {
        pages.append(Document.Page(pageNumber: number, pageContent: pageString, images: nil))
    }
}
