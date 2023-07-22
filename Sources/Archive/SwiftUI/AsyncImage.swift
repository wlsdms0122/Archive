//
//  AsyncImage.swift
//
//
//  Created by JSilver on 2023/07/20.
//

import SwiftUI

public struct AsyncImage<
    Content: View,
    Placeholder: View
>: View {
    // MARK: - View
    public var body: some View {
        Group {
            if let image {
                content(
                    Image(uiImage: image)
                )
            } else {
                placeholder
            }
        }
        .onAppear {
            Task.detached {
                image = await ImageLoader.shared.load(url: url)
            }
        }
    }
    
    // MARK: - Property
    @State
    private var image: UIImage?
    
    private let url: URL?
    private let scale: CGFloat
    private let content: (Image) -> Content
    private let placeholder: Placeholder
    
    // MARK: - Initializer
    public init(
        url: URL?,
        scale: CGFloat = 1,
        @ViewBuilder content: @escaping (Image) -> Content = { $0 },
        @ViewBuilder placeholder: () -> Placeholder = { Color(.systemGray) }
    ) {
        self.url = url
        self.scale = scale
        self.content = content
        self.placeholder = placeholder()
    }
}
