//
//  OptionalState.swift
//
//
//  Created by JSilver on 2023/01/24.
//

import Foundation
import SwiftUI

@propertyWrapper
public struct OptionalState<T>: DynamicProperty {
    // MARK: - Property
    private let state: State<T>
    private var binding: Binding<T>?
    
    public var wrappedValue: T {
        get {
            projectedValue.wrappedValue
        }
        nonmutating set {
            projectedValue.wrappedValue = newValue
        }
    }
    
    public var projectedValue: Binding<T> {
        binding ?? state.projectedValue
    }
    
    // MARK: - Initializer
    public init(wrappedValue: T) {
        self.state = .init(initialValue: wrappedValue)
        self.binding = nil
    }
    
    public init(_ wrappedValue: T, binding: Binding<T>? = nil) {
        self.state = .init(initialValue: wrappedValue)
        self.binding = binding
    }
    
    // MARK: - Public
    public mutating func bind(_ binding: Binding<T>) {
        self.binding = binding
    }
    
    // MARK: - Private
}
