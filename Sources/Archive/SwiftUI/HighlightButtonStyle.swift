//
//  HighlightButtonStyle.swift
//
//
//  Created by JSilver on 2023/02/25.
//

import SwiftUI

public extension ButtonStyle {
    static func highlight(_ isHighlight: Binding<Bool>) -> Self where Self == HighlightButtonStyle {
        HighlightButtonStyle(isHighlight)
    }
}

public struct HighlightButtonStyle: ButtonStyle {
    // MARK: - Property
    @Binding
    public var isHighlight: Bool
    
    // MARK: - Initializer
    public init(_ isHighlight: Binding<Bool>) {
        self._isHighlight = isHighlight
    }
    
    // MARK: - Lifeycle
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) {
                isHighlight = $0
            }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
