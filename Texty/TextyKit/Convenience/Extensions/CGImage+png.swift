//
//  CGImage+png.swift
//  TextyKit
//
//  Created by Kai Aldag on 2020-03-30.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import UIKit

public extension CGImage {
    var png: Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}

