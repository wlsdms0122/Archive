//
//  Iterator.swift
//
//
//  Created by JSilver on 2023/03/23.
//

import SwiftUI

public struct Iterator<Data, Content: View>: View {
    // MARK: - View
    public var body: some View {
        let views = data.map { content($0) }
        ForEach(0..<views.count, id: \.self) {
            views[$0]
        }
    }
    
    // MARK: - Property
    private let data: [Data]
    private let content: (Data) -> Content
    
    // MARK: - Initializer
    public init(
        _ data: [Data],
        @ViewBuilder content: @escaping (Data) -> Content
    ) {
        self.data = data
        self.content = content
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
