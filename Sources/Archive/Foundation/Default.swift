//
//  Default.swift
//
//
//  Created by JSilver on 2023/03/04.
//

import Foundation

@propertyWrapper
public struct Default<Value> {
    private let `default`: Value
    public var wrappedValue: Value?
    
    public var projectedValue: Value {
        get {
            wrappedValue ?? `default`
        }
        set {
            wrappedValue = newValue
        }
    }
    
    init(wrappedValue: Value? = nil, _ default: Value) {
        self.default = `default`
        self.wrappedValue = wrappedValue
    }
}
