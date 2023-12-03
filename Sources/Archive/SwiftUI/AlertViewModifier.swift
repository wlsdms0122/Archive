//
//  AlertViewModifier.swift
//
//
//  Created by jsilver on 12/3/23.
//

import SwiftUI
import Combine
import JSToast

public enum AlertStrategy {
    case queue
    case override
    case ignore
}

final class AlertQueue: ObservableObject {
    // MARK: - Property
    private static var queues: [UIWindowScene?: AlertQueue] = [:]
    static func queue(scene: UIWindowScene?) -> AlertQueue {
        guard let queue = queues[scene] else {
            let queue = AlertQueue()
            queues[scene] = queue
            return queue
        }
        
        return queue
    }
    
    @Published
    private(set) var item: (id: Namespace.ID, data: Any)?
    
    var isEmpty: Bool { queue.isEmpty }
    
    private var queue: [(Namespace.ID, Any)] = []
    
    // MARK: - Initializer
    private init() { }
    
    // MARK: - Public
    func insert(_ data: Any, for id: Namespace.ID) {
        queue.append((id, data))
    }
    
    func remove() {
        guard !queue.isEmpty else { return }
        queue.removeLast()
    }
    
    func removeAll() {
        queue.removeAll()
    }
    
    func reset() {
        item = nil
    }
    
    func check() {
        item = queue.last
    }
    
    // MARK: - Private
}

struct AlertViewModifier<Data, Alert: View>: ViewModifier {
    // MARK: - Property
    private let publisher: AnyPublisher<Data, Never>
    private let duration: TimeInterval?
    private let strategy: AlertStrategy
    private let alert: (Data, _ dismiss: @escaping ((() -> Void)?) -> Void) -> Alert
    
    @Namespace
    private var id: Namespace.ID
    @State
    private var isShow: Bool = false
    @State
    private var scene: UIWindowScene?
    
    // MARK: - Initializer
    init<P: Publisher>(
        _ publisher: P,
        duration: TimeInterval? = nil,
        strategy: AlertStrategy = .queue,
        @ViewBuilder alert: @escaping (Data, _ dismiss: @escaping ((() -> Void)?) -> Void) -> Alert
    ) where P.Output == Data, P.Failure == Never {
        self.publisher = publisher.eraseToAnyPublisher()
        self.duration = duration
        self.strategy = strategy
        self.alert = alert
    }
    
    // MARK: - Lifecycle
    func body(content: Content) -> some View {
        content.background(
            ToastContainer { layer in
                if let view = layer.view {
                    Group {
                        if let scene = scene {
                            let queue = AlertQueue.queue(scene: scene)
                            
                            GeometryReader { reader in
                                let frame = reader.frame(in: .global)
                                
                                Color.clear
                                    .toast(
                                        $isShow,
                                        duration: duration,
                                        layouts: [
                                            .inside(.top),
                                            .inside(.trailing),
                                            .inside(.bottom),
                                            .inside(.leading)
                                        ],
                                        showAnimation: .fadeIn(duration: 0.25),
                                        hideAnimation: .fadeOut(duration: 0.25),
                                        hidden: { _ in
                                            queue.check()
                                        }
                                    ) {
                                        if let data = queue.item?.data as? Data {
                                            var completion: (() -> Void)?
                                            
                                            alert(data) {
                                                completion = $0
                                                
                                                queue.remove()
                                                queue.reset()
                                            }
                                                .onDisappear {
                                                    completion?()
                                                }
                                        }
                                    }
                                        .offset(
                                            x: -frame.minX,
                                            y: -frame.minY
                                        )
                            }
                                .frame(
                                    width: scene.screen.bounds.width,
                                    height: scene.screen.bounds.height
                                )
                                .subscribe(queue.$item) { item in
                                    guard item?.id == id else {
                                        isShow = false
                                        return
                                    }
                                    
                                    isShow = (item?.data as? Data) != nil
                                }
                        }
                    }
                        .subscribe(view.publisher(for: \.window?.windowScene)) { scene in
                            self.scene = scene
                        }
                        .subscribe(publisher) { data in
                            guard let scene = scene else { return }
                            
                            let queue = AlertQueue.queue(scene: scene)
                            
                            Task {
                                if queue.isEmpty {
                                    queue.insert(data, for: id)
                                    queue.check()
                                } else {
                                    switch strategy {
                                    case .queue:
                                        queue.insert(data, for: id)
                                        queue.reset()
                                        
                                    case .override:
                                        queue.removeAll()
                                        queue.insert(data, for: id)
                                        queue.reset()
                                        
                                    case .ignore:
                                        break
                                    }
                                }
                            }
                        }
                }
            }
        )
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension View {
    func alert<
        Data,
        P: Publisher,
        Alert: View
    >(
        _ publisher: P,
        duration: TimeInterval? = nil,
        strategy: AlertStrategy = .override,
        @ViewBuilder alert: @escaping (Data, _ dismiss: @escaping ((() -> Void)?) -> Void) -> Alert
    ) -> some View where P.Output == Data, P.Failure == Never {
        modifier(AlertViewModifier(
            publisher,
            duration: duration,
            strategy: strategy,
            alert: alert
        ))
    }
}

#if DEBUG
private struct Preview: View {
    var body: some View {
        Button("Show Alert") {
            alert.send(Void())
        }
            .buttonStyle(.borderedProminent)
            .fixedSize()
            .alert(alert) { _, dismiss in
                ZStack {
                    Color.black.opacity(0.4)
                    
                    VStack(spacing: 2) {
                        VStack(spacing: 2) {
                            Text("A Short Title Is Best")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.top, 21.5)
                                .padding(.bottom, 2.5)
                            Text("A message should be a short, complete sentence.")
                                .multilineTextAlignment(.center)
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .padding(.top, 2.5)
                                .padding(.bottom, 17.5)
                        }
                        VStack(spacing: 0) {
                            Divider()
                            Button {
                                dismiss(nil)
                            } label: {
                                Text("Action")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.blue)
                                    .frame(height: 44)
                                    .frame(maxWidth: .infinity)
                            }
                            Divider()
                            Button {
                                dismiss(nil)
                            } label: {
                                Text("Action")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.blue)
                                    .frame(height: 44)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .frame(width: 247)
                    .background(.regularMaterial)
                    .cornerRadius(14)
                }
            }
    }
    
    let alert = PassthroughSubject<Void, Never>()
}

#Preview {
    Preview()
}
#endif
