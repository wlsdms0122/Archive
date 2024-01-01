//
//  AlertViewModifier.swift
//
//
//  Created by JSilver on 2023/03/21.
//

import SwiftUI
import Combine
import JSToast

public enum AlertStrategy {
    case queue
    case override
    case ignore
}

@MainActor
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
    
    func removeAll(id: Namespace.ID? = nil) {
        guard let id = id else {
            queue.removeAll()
            return
        }
        
        queue.removeAll { item in item.0 == id }
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
    
    // MARK: - Initializer
    init<P: Publisher>(
        _ publisher: P,
        duration: TimeInterval?,
        strategy: AlertStrategy,
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
            ToastLayerReader { layer in
                ToastReader { toaster in
                    if let scene = layer.scene {
                        let queue = AlertQueue.queue(scene: scene)
                        var completion: (() -> Void)?
                        
                        Color.clear
                            .subscribe(queue.$item) { item in
                                guard let data = item?.data as? Data, item?.id == id else {
                                    // If current alert data isn't own, hide current alert.
                                    toaster.hide(animation: .fadeOut(duration: 0.25)) { _ in
                                        // Check next alert data and call completion handler.
                                        queue.check()
                                        
                                        completion?()
                                        completion = nil
                                    }
                                    
                                    return
                                }
                                
                                // If current alert data is own, show new alert.
                                toaster.show(
                                    layouts: [
                                        .inside(.top),
                                        .inside(.trailing),
                                        .inside(.bottom),
                                        .inside(.leading)
                                    ],
                                    scene: layer,
                                    showAnimation: .fadeIn(duration: 0.25)
                                ) {
                                    alert(data) {
                                        completion = $0
                                        
                                        // If user confirm alert remove current item and reset to hide.
                                        queue.remove()
                                        queue.reset()
                                    }
                                }
                            }
                            .onDisappear {
                                // If the request view has disappeared, remove all data that occurred on view(id),
                                // and reset to hide the current alert. Check the next alert data after animation completion.
                                queue.removeAll(id: id)
                                queue.reset()
                                
                                toaster.hide(animation: .fadeOut(duration: 0.25)) { _ in
                                    queue.check()
                                }
                            }
                            .subscribe(publisher) { data in
                                Task {
                                    guard !queue.isEmpty else {
                                        // Insert data into alert queue and check it to present immediatly if queue is empty.
                                        queue.insert(data, for: id)
                                        queue.check()
                                        return
                                    }
                                    
                                    // If queue isn't empty, insert data through queue strategy.
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
