//
//  Collection+Safe.swift
//  
//
//  Created by jsilver on 2022/02/12.
//

import Foundation

public extension Collection {
    subscript(safe index: Index) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
    
    subscript(safe range: Range<Index>) -> SubSequence? {
        guard range.lowerBound >= startIndex && range.upperBound <= endIndex else { return nil }
        return self[range]
    }
    
    subscript(safe range: ClosedRange<Index>) -> SubSequence? {
        guard range.lowerBound >= startIndex && range.upperBound <= endIndex else { return nil }
        return self[range]
    }
}
