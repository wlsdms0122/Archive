//
//  Config.swift
//
//
//  Created by JSilver on 2023/03/04.
//

import Foundation

@propertyWrapper
public struct Config<Value> {
    private var set: Bool = false
    public var wrappedValue: Value {
        didSet {
            set = true
        }
    }
    
    public var projectedValue: (Value) -> Value {
        {
            set ? wrappedValue : $0
        }
    }
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}
