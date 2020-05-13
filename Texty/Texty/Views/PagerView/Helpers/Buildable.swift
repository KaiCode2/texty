//
//  Buildable.swift
//  Texty
//
//  Created by Kai Aldag on 2020-05-12.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import Foundation

/// Adds a helper function to mutate a properties and help implement _Builder_ pattern
protocol Buildable { }

extension Buildable {

    /// Mutates a property of the instance
    ///
    /// - Parameter keyPath:    `WritableKeyPath` to the instance property to be modified
    /// - Parameter value:      value to overwrite the  instance property
    func mutating<T>(keyPath: WritableKeyPath<Self, T>, value: T) -> Self {
        var newSelf = self
        newSelf[keyPath: keyPath] = value
        return newSelf
    }

}
