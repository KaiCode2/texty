//
//  Optional+Unwrap.swift
//  Texty
//
//  Created by Kai Aldag on 2020-03-14.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import Foundation

public extension Optional {
    func unwrap() throws -> Wrapped {
        if case .some(let wrappedValue) = self {
            return wrappedValue
        } else {
            throw LocalError.unwrappedNil
        }
    }
}
