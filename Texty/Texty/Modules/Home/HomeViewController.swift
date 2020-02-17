//
//  ViewController.swift
//  Texty
//
//  Created by Kai Aldag on 2019-06-07.
//  Copyright © 2019 Kai Aldag. All rights reserved.
//

import UIKit
import Vision
import VisionKit
import AVFoundation

class HomeViewController: UIViewController {
    private let presenter: HomePresenter

    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func didTapAdd(_ sender: Any) {
        presenter.didRequestAdd()
    }
}

