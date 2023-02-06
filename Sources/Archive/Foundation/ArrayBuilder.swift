//
//  ArrayBuilder.swift
//
//
//  Created by jsilver on 2022/08/15.
//

import Foundation

@resultBuilder
struct ArrayBuilder<Element> {
    static func buildBlock(_ components: Element...) -> [Element] {
        components
    }
}
