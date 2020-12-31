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
    var pages: [Page] {
        didSet {
            metaData.pageCount = pages.count
        }
    }


    var metaData: MetaData
    private(set) var isPagesLoaded: Bool


    var id: UUID {
        return metaData.id
    }

    /// MARK: -- Initializers and Setters --

    init(pages: [Page], metaData: MetaData) {
        self.pages = pages
        self.metaData = metaData

        self.isPagesLoaded = pages.count != (metaData.pageCount - 1)
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

        var title: String
        var author: String
        var releaseDate: Date
        var pageCount: Int

        var coverImage: UIImage?


        /// MARK: -- Initializers and Setters --
        init(id: UUID = UUID(), title: String = "", author: String = "", releaseDate: Date = Date(), pageCount: Int = 0, coverImage: UIImage? = nil) {
            self.id = id
            self.title = title
            self.author = author
            self.releaseDate = releaseDate
            self.pageCount = pageCount
            self.coverImage = coverImage
        }

        static func empty() -> MetaData {
            return MetaData(id: UUID(), title: "", author: "", releaseDate: Date(), pageCount: 0, coverImage: nil)
        }

        static func fromDict(dict: [String: Any?]) throws -> MetaData {
            guard let id = dict[Document.propertyKeys[0]] as? UUID,
                  let title = dict[Document.propertyKeys[1]] as? String,
                let author = dict[Document.propertyKeys[2]] as? String,
                let date = dict[Document.propertyKeys[3]] as? Date,
                let pageCount = dict[Document.propertyKeys[4]] as? Int else {
                throw LocalError.invalidInput
            }

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
                Document.propertyKeys[1]: title,
                Document.propertyKeys[2]: author,
                Document.propertyKeys[3]: releaseDate,
                Document.propertyKeys[4]: pageCount
            ]

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

    mutating func add(pageString: String, number: Int? = nil, image: CGImage? = nil) {
        var number = number
        if number == nil {
            if let last = pages.last?.pageNumber {
                number = last + 1
            } else {
                number = 0
            }
        }
        pages.append(Document.Page(pageNumber: number!, pageContent: pageString, image: image))
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
