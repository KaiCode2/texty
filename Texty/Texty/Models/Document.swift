//
//  Document.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-03.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI
import Combine
import UIKit
import TextyKit

struct Document: Identifiable {
    var pages: [Page]
    let metaData: MetaData

    init(pages: [Page], metaData: MetaData) {
        self.pages = pages
        self.metaData = metaData
    }


    var id: UUID {
        return metaData.id
    }

    struct Page: Identifiable, Hashable {
        var id: Int {
            return pageNumber
        }

        let pageNumber: Int
        let pageContent: String
        let image: CGImage?

        static func fromDict(dict: [String: Any?]) throws -> Page {
            guard let pageContent = dict["pageContent"] as? String,
                let number = dict["pageNumber"] as? Int else {
                throw LocalError.invalidInput
            }
            /// TODO: Sort this out later
//            let image = CGImage(dict["image"])

            return Page(pageNumber: number, pageContent: pageContent, image: nil)
        }

        func toDict() -> [String: Any] {
            var dict: [String: Any] = [
                Page.propertyKeys[0]: pageContent,
                Page.propertyKeys[1]: pageNumber
            ]

            if let imageData = image?.png {
                dict[Page.propertyKeys[2]] = imageData
            }
            return dict
        }

        static let propertyKeys = [
            "pageContent",
            "pageNumber",
            "image"
        ]
    }
    struct MetaData: Identifiable, Hashable {
        typealias ID = UUID
        var id: UUID

        let title: String?
        let author: String?
        let releaseDate: Date
        let pageCount: Int?

        var coverImage: UIImage?
//        {
//            didSet(newValue) {
//                if newValue == nil {
//                    if let pageCount = pageCount {
//                        let isMultiplePages = pageCount > 1
//                        self.coverImage = isMultiplePages ? Image(systemName: "book") : Image(systemName: "doc")
//                    } else {
//                        self.coverImage = Image(systemName: "doc")
//                    }
//                }
//            }
//        }

        static func empty() -> MetaData {
            return MetaData(id: UUID(), title: nil, author: nil, releaseDate: Date(), pageCount: nil, coverImage: nil)
        }

        static func fromDict(dict: [String: Any?]) throws -> MetaData {
            guard let id = dict[Document.propertyKeys[0]] as? UUID ,
                let date = dict[Document.propertyKeys[3]] as? Date else {
                throw LocalError.invalidInput
            }
            let title = dict[Document.propertyKeys[1]] as? String
            let author = dict[Document.propertyKeys[2]] as? String
            let pageCount = dict[Document.propertyKeys[4]] as? Int

            var coverImage: UIImage? = nil
            if let imageData = dict[Document.propertyKeys[5]] as? Data,
                let image = UIImage(data: imageData) {
                coverImage = image
            }

            return MetaData(id: id, title: title, author: author, releaseDate: date, pageCount: pageCount, coverImage: coverImage)
        }

        func toDict() -> [String: Any] {
            var dict: [String: Any] = [
                Document.propertyKeys[0]: id,
                Document.propertyKeys[3]: releaseDate
            ]
            if let title = title {
                dict[Document.propertyKeys[1]] = title
            }
            if let author = author {
                dict[Document.propertyKeys[2]] = author
            }
            if let pageCount = pageCount {
                dict[Document.propertyKeys[4]] = pageCount
            }
            if let coverImageData = coverImage?.pngData() {
                dict[Document.propertyKeys[5]] = coverImageData
            }
            return dict
        }

        static func == (lhs: MetaData, rhs: MetaData) -> Bool {
            return lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    var aggragatedText: String {
        return self.pages.reduce("") { (aggregatedText, nextPage) -> String in
            return aggregatedText + " " + nextPage.pageContent
        }
    }

    mutating func add(pageString: String, number: Int? = nil) {
        var number = number
        if number == nil {
            if let last = pages.last?.pageNumber {
                number = last + 1
            } else {
                number = 0
            }
        }
        pages.append(Document.Page(pageNumber: number!, pageContent: pageString, image: nil))
    }

    static let propertyKeys = [
        "id",
        "title",
        "author",
        "date",
        "pageCount",
        "coverImage",
    ]
}

extension Document: Hashable {
    static func == (lhs: Document, rhs: Document) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Document {
    static func fromDict(dict: [String: Any]) throws -> Document {
        throw LocalError.invalidInput
    }
}
