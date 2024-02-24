//
//  Binding+Extension.swift
//
//
//  Created by jsilver on 2/24/24.
//

import SwiftUI

public extension Binding {
    init<V>(_ base: Binding<V>, get: @escaping (V) -> Value, set: @escaping (Value) -> Void) {
        self.init {
            get(base.wrappedValue)
        } set: {
            set($0)
        }
    }
}

public extension Binding {
    static func map<V>(
        _ base: Binding<V?>,
        transfrom: @escaping (V?) -> Value?
    ) -> Binding<Value?> {
        .init(base) {
            transfrom($0)
        } set: {
            guard $0 == nil else { return }
            base.wrappedValue = nil
        }
    }
}

public extension Binding where Value == Bool {
    static func select<V>(
        _ value: V,
        of base: Binding<V?>
    ) -> Binding<Value>
    where V: Equatable {
        .init(base) {
            $0 == value
        } set: {
            base.wrappedValue = $0 ? value : nil
        }
    }
}
