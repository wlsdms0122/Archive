//
//  ArrayBuilder.swift
//
//
//  Created by jsilver on 2022/08/15.
//

import Foundation

@resultBuilder
public struct ArrayBuilder<Element> {
    public static func buildBlock(_ components: Element...) -> [Element] {
        return components
    }
    
    public static func buildArray(_ components: [[Element]]) -> [Element] {
        return components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [Element]?) -> [Element] {
        return component ?? []
    }
    
    public static func buildEither(first component: [Element]) -> [Element] {
        return component
    }
    
    public static func buildEither(second component: [Element]) -> [Element] {
        return component
    }
    
    public static func buildIf(_ element: [Element]?) -> [Element] {
        element ?? []
    }
    
    public static func buildPartialBlock(first: Element) -> [Element] {
        [first]
    }
    
    public static func buildPartialBlock(first: [Element]) -> [Element] {
        first
    }
    
    public static func buildPartialBlock(accumulated: [Element], next: Element) -> [Element] {
        accumulated + [next]
    }
    
    public static func buildPartialBlock(accumulated: [Element], next: [Element]) -> [Element] {
        accumulated + next
    }
}
