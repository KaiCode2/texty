//
//  EditDocumentViewController.swift
//  Texty
//
//  Created by Kai Aldag on 2020-02-05.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import UIKit

internal final class EditDocumentViewController: UIViewController {
    private let presenter: EditDocumentPresenter

    init(presenter: EditDocumentPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
