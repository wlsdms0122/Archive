//
//  NoneButtonStyle.swift
//
//
//  Created by JSilver on 2023/02/24.
//

import SwiftUI

public extension ButtonStyle where Self == NoneButtonStyle {
    static var none: Self { NoneButtonStyle() }
}

public struct NoneButtonStyle: ButtonStyle {
    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .transaction { $0.animation = nil }
    }
}
