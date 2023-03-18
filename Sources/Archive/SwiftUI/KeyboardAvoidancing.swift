//
//  KeyboardAvoidancing.swift
//
//
//  Created by JSilver on 2023/03/11.
//

import Foundation
import SwiftUI
import Combine

public enum KeyboardState {
    case willShow
    case didShow
    case willHide
    case didHide
}

struct OnKeyboardStateChangeModifier: ViewModifier {
    // MARK: - Property
    var action: (KeyboardState, [AnyHashable: Any]) -> Void
    
    // MARK: - Initializer
    init(action: @escaping (KeyboardState, [AnyHashable: Any]) -> Void) {
        self.action = action
    }
    
    // MARK: - Lifecycle
    func body(content: Content) -> some View {
        content.onReceive(
            Publishers.Merge4(
                NotificationCenter.Publisher(
                    center: .default,
                    name: UIResponder.keyboardWillShowNotification
                )
                    .map { (KeyboardState.willShow, $0) },
                NotificationCenter.Publisher(
                    center: .default,
                    name: UIResponder.keyboardDidShowNotification
                )
                    .map { (KeyboardState.didShow, $0) },
                NotificationCenter.Publisher(
                    center: .default,
                    name: UIResponder.keyboardWillHideNotification
                )
                    .map { (KeyboardState.willHide, $0) },
                NotificationCenter.Publisher(
                    center: .default,
                    name: UIResponder.keyboardDidHideNotification
                )
                    .map { (KeyboardState.didHide, $0) }
            )
        ) { state, output in
            guard let userInfo = output.userInfo else { return }
            action(state, userInfo)
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

struct OnKeyboardAvoidancingChangedModifier: ViewModifier {
    // MARK: - Property
    var offset: CGFloat
    var action: (CGFloat) -> Void
    
    @State
    private var viewFrame: CGRect?
    @State
    private var keyboardState: KeyboardState?
    @State
    private var keyboardFrame: CGRect?
    
    // MARK: - Initializer
    init(offset: CGFloat = 0, action: @escaping (CGFloat) -> Void) {
        self.offset = offset
        self.action = action
    }
    
    // MARK: - Lifecycle
    func body(content: Content) -> some View {
        var adjustedOffset: CGFloat = 0
        if let viewFrame = viewFrame,
           let keyboardFrame = keyboardFrame,
           let keyboardState = keyboardState {
            switch keyboardState {
            case .willShow, .didShow:
                adjustedOffset = min(max(viewFrame.maxY - keyboardFrame.minY + offset, 0), keyboardFrame.height + offset)
                
            default:
                break
            }
        }
        
        return content.overlay(
            GeometryReader { reader in
                let frame = reader.frame(in: .global)
                
                Color.clear
                    .onAppear {
                        viewFrame = frame
                    }
                    .onChange(of: frame) { frame in
                        viewFrame = frame
                    }
            }
        )
            .onKeyboardStateChanged { state, userInfo in
                keyboardState = state
                keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }
            .onChange(of: adjustedOffset) { offset in
                action(offset)
            }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

struct KeyboardAvoidanceModifier: ViewModifier {
    // MARK: - Property
    var offset: CGFloat
    
    @State
    private var avoidancingOffset: CGFloat = 0
    
    // MARK: - Initializer
    init(offset: CGFloat = 0) {
        self.offset = offset
    }
    
    // MARK: - Lifecycle
    func body(content: Content) -> some View {
        content.offset(y: -avoidancingOffset)
            .onKeyboardAvoidancingChanged(offset: offset) { offset in
                withAnimation(.easeInOut(duration: 0.25)) {
                    avoidancingOffset = offset
                }
            }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public struct KeyboardAvoidancingView<Content: View>: View {
    // MARK: - View
    public var body: some View {
        content().padding(.bottom, avoidancingOffset)
            .onKeyboardAvoidancingChanged(offset: offset) { offset in
                withAnimation(.easeInOut(duration: 0.25)) {
                    avoidancingOffset = offset
                }
            }
    }
    
    // MARK: - Property
    public var offset: CGFloat
    public var content: () -> Content
    
    @State
    private var avoidancingOffset: CGFloat = 0
    
    // MARK: - Initializer
    public init(offset: CGFloat = 0, @ViewBuilder content: @escaping () -> Content) {
        self.offset = offset
        self.content = content
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension View {
    func onKeyboardStateChanged(action: @escaping (KeyboardState, [AnyHashable: Any]) -> Void) -> some View {
        modifier(OnKeyboardStateChangeModifier(action: action))
    }
    
    func onKeyboardAvoidancingChanged(offset: CGFloat = 0, action: @escaping (CGFloat) -> Void) -> some View {
        modifier(OnKeyboardAvoidancingChangedModifier(offset: offset, action: action))
    }
    
    func keyboardAvoidancing(offset: CGFloat = 0) -> some View {
        modifier(KeyboardAvoidanceModifier(offset: offset))
    }
}
