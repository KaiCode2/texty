//
//  View+Helper.swift
//  Texty
//
//  Created by Kai Aldag on 2020-05-12.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI

extension View {

    func frame(size: CGSize) -> some View {
        frame(width: size.width, height: size.height)
    }

}
