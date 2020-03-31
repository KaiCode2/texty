//
//  Document.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-03.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI
import Combine
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

    struct Page {
        let pageNumber: Int?
        let pageContent: String
        let image: CGImage?

        static func fromDict(dict: [String: Any?]) throws -> Page {
            guard let pageContent = dict["pageContent"] as? String else {
                throw LocalError.invalidInput
            }
            let number = dict["pageNumber"] as? Int
            /// TODO: Sort this out later
//            let image = CGImage(dict["image"])

            return Page(pageNumber: number, pageContent: pageContent, image: nil)
        }
    }
    struct MetaData: Identifiable, Hashable {
        typealias ID = UUID
        var id: UUID

        let title: String?
        let author: String?
        let releaseDate: Date?
        let pageCount: Int?

        var coverImage: Image?
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
            return MetaData(id: UUID(), title: nil, author: nil, releaseDate: nil, pageCount: nil, coverImage: nil)
        }

        static func fromDict(dict: [String: Any?]) throws -> MetaData {
            guard let id = dict[Document.propertyKey[0]] as? UUID else {
                throw LocalError.invalidInput
            }
            let title = dict[Document.propertyKey[1]] as? String
            let author = dict[Document.propertyKey[2]] as? String
            let date = dict[Document.propertyKey[3]] as? Date
            let pageCount = dict[Document.propertyKey[4]] as? Int

            let coverImage = dict[Document.propertyKey[5]] as? Image

            return MetaData(id: id, title: title, author: author, releaseDate: date, pageCount: pageCount, coverImage: coverImage)
        }

        func toDict() -> [String: Any] {
            return [:]
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
        pages.append(Document.Page(pageNumber: number, pageContent: pageString, image: nil))
    }

    static let propertyKey = [
        "id",
        "title",
        "author",
        "date",
        "pageCount",
        "coverImage",
        "pagesIds", /// TODO: stop storing IDs and use core data relationships
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
