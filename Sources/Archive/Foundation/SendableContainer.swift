//
//  SendableContainer.swift
//
//
//  Created by JSilver on 2023/09/21.
//

import Foundation

public actor SendableContainer<T> {
    // MARK: - Property
    public private(set) var value: T
    
    // MARK: - Initializer
    public init(_ value: T) {
        self.value = value
    }
    
    public init(_ value: T = nil) where T: ExpressibleByNilLiteral {
        self.value = nil
    }
    
    // MARK: - Public
    public func set(_ value: T) {
        self.value = value
    }
    
    // MARK: - Private
}
