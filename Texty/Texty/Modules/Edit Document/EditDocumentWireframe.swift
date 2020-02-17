//
//  EditDocumentWireframe.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-05.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import Foundation

protocol EditDocumentDelegate: DismissableDelegate {
    func didRequestAddCover()
    func didRequestEditScan()
}

internal final class EditDocumentWireframe {
    private let moduleDelegate: EditDocumentDelegate

    init(delegate: EditDocumentDelegate) {
        self.moduleDelegate = delegate
    }

    
}
