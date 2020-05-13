//
//  UIApplication+EndEditing.swift
//  TextyKit
//
//  Created by Kai Aldag on 2020-05-13.
//  Copyright © 2020 Kai Aldag. All rights reserved.
//

import UIKit

public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
