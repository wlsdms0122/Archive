//
//  String+Localized.swift
//  
//
//  Created by jsilver on 2021/05/29.
//

import Foundation

public extension String {
    var localized: String {
        NSLocalizedString(self, bundle: .module, comment: "")
    }
}
