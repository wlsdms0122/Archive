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
    private let state: State<T>
    private let binding: Binding<T>?
    
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
    
    public init(_ wrappedValue: T, binding: Binding<T>? = nil) {
        self.state = .init(initialValue: wrappedValue)
        self.binding = binding
    }
}
