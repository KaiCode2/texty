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

//        let lines: [String]
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
        return self.pages.reduce("") { (aggregatedText, nextPage) -> String in
            return aggregatedText + " " + nextPage.pageContent
        }
    }

    mutating func add(pageString: String, number: Int? = nil) {
        pages.append(Document.Page(pageNumber: number, pageContent: pageString, images: nil))
    }
}
