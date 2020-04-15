//
//  LazyView.swift
//  TextyKit
//
//  Created by Kai Aldag on 2020-04-15.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import SwiftUI

public struct LazyView<Content: View>: View {
    public let build: () -> Content
    
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    public var body: Content {
        build()
    }
}
