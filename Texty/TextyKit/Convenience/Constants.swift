//
//  Constants.swift
//  Texty
//
//  Created by Kai Aldag on 2020-03-14.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import UIKit

public enum Constants {
    public enum CoreData {
        public static let DocumentsModel = "DocumentModel"
        public static let DocumentObject = "Document"
        public static let PageModel = "PageModel"

        public static let pagesRelation = "pages"
    }

    public enum Images {
        public static let camera = UIImage(systemName: "camera")!
    }

    public enum Published {
        public static let metaData = "metaData"
    }

    public enum Text {
        public static let indent = "    "
    }
}
