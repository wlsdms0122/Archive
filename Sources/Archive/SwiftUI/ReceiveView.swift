//
//  ReceiveView.swift
//  
//
//  Created by jsilver on 2022/06/13.
//

import SwiftUI
import Combine

/// View similar to subscription view functionally.
/// It to fix `SwiftUI` issue that publisher is cancelled in `.onReceive()` when view re-rendered.
public struct StateSubscriptionView<
    V: View,
    P: Publisher
>: View where P.Failure == Never {
    // MARK: - View
    public var body: some View {
        content.onReceive(viewModel.output) { action($0) }
    }
    
    // MARK: - Property
    @StateObject
    private var viewModel: ReceiveViewModel<P>
    
    private let content: V
    private let action: (P.Output) -> Void
    
    // MARK: - Initializer
    public init(
        publisher: P,
        content: V,
        perform action: @escaping (P.Output) -> Void
    ) {
        self._viewModel = .init(wrappedValue: ReceiveViewModel(publisher))
        
        self.content = content
        self.action = action
    }
    
    public init(
        publisher: P,
        @ViewBuilder content: () -> V,
        perform action: @escaping (P.Output) -> Void
    ) {
        self.init(publisher: publisher, content: content(), perform: action)
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

class ReceiveViewModel<P: Publisher>: ObservableObject where P.Failure == Never {
    // MARK: - Property
    let output: P
    
    // MARK: - Initializer
    init(_ publisher: P) {
        output = publisher
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension View {
    func subscribe<P: Publisher>(
        _ publisher: P,
        perform action: @escaping (P.Output) -> Void
    ) -> some View where P.Failure == Never {
        StateSubscriptionView(
            publisher: publisher,
            content: self,
            perform: action
        )
    }
}
