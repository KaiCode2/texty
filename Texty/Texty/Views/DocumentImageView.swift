//
//  DocumentImageView.swift
//  Texty
//
//  Created by Kai Aldag on 2020-04-04.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI
import TextyKit

struct DocumentImageView: View {
    fileprivate let image: UIImage

    init(image: UIImage?) {
        self.image = image ?? Constants.Images.camera
    }


    var body: some View {
        EmptyView()
    }
}

