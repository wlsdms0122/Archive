//
//  EnvironmentState.swift
//
//
//  Created by JSilver on 2023/03/04.
//

import SwiftUI

@propertyWrapper
public struct EnvironmentState<T>: DynamicProperty {
    private let state: State<T>
    @SwiftUI.Environment
    private var environment: Binding<T>?
    
    public var wrappedValue: T {
        get {
            projectedValue.wrappedValue
        }
        nonmutating set {
            projectedValue.wrappedValue = newValue
        }
    }
    
    public var projectedValue: Binding<T> {
        environment ?? state.projectedValue
    }
    
    public init(
        wrappedValue: T,
        _ keyPath: KeyPath<EnvironmentValues, Binding<T>?>
    ) {
        self.state = .init(initialValue: wrappedValue)
        self._environment = .init(keyPath)
    }
}
