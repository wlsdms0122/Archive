//
//  StringCountValidator.swift
//  
//
//  Created by jsilver on 2022/01/27.
//

import Foundation

public struct StringCountValidator: Validator {
    private let count: Int
    private let compare: (Int, Int) -> Bool
    
    public init(count: Int, _ compare: @escaping (Int, Int) -> Bool) {
        self.count = count
        self.compare = compare
    }
    
    public func validate(_ input: String) -> Bool {
        compare(input.count, count)
    }
}
