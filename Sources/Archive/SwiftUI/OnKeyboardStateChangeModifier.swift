//
//  OnKeyboardStateChangeModifier.swift
//
//
//  Created by JSilver on 2023/03/11.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Keyboard State Change
public struct OnKeyboardStateChangeModifier: ViewModifier {
    public enum State {
        case willShow
        case didShow
        case willHide
        case didHide
    }
    
    // MARK: - Property
    public var action: (State, CGRect) -> Void
    
    // MARK: - Initializer
    public init(action: @escaping (State, CGRect) -> Void) {
        self.action = action
    }
    
    // MARK: - Lifecycle
    public func body(content: Content) -> some View {
        content.onReceive(
            Publishers.Merge4(
                NotificationCenter.Publisher(
                    center: .default,
                    name: UIResponder.keyboardWillShowNotification
                )
                    .map { (State.willShow, $0) },
                NotificationCenter.Publisher(
                    center: .default,
                    name: UIResponder.keyboardDidShowNotification
                )
                    .map { (State.didShow, $0) },
                NotificationCenter.Publisher(
                    center: .default,
                    name: UIResponder.keyboardWillHideNotification
                )
                    .map { (State.willHide, $0) },
                NotificationCenter.Publisher(
                    center: .default,
                    name: UIResponder.keyboardDidHideNotification
                )
                    .map { (State.didHide, $0) }
            )
        ) { state, output in
            guard let frame = output.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            action(state, frame)
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

// MARK: - Keyboard Avoidance
public struct KeyboardAvoidanceModifier: ViewModifier {
    // MARK: - Property
    public var offset: CGFloat
    
    @State
    private var viewOffset: CGFloat?
    @State
    private var keyboardOffset: CGFloat?
    
    private var adjustedOffset: CGFloat {
        min(max((viewOffset ?? 0) - (keyboardOffset ?? 0), 0), (keyboardOffset ?? 0))
    }
    
    
    // MARK: - Initializer
    public init(offset: CGFloat = 0) {
        self.offset = offset
    }
    
    // MARK: - Lifecycle
    public func body(content: Content) -> some View {
        content.animation(.easeOut(duration: 0.25), value: adjustedOffset)
            .offset(y: -adjustedOffset)
            .overlay(GeometryReader { reader in
                let frame = reader.frame(in: .global)
                
                Color.clear
                    .onAppear {
                        viewOffset = frame.maxY
                    }
                    .onChange(of: frame) { frame in
                        viewOffset = frame.maxY
                    }
            })
            .onKeyboardStatechanged { state, frame in
                switch state {
                case .willShow, .didShow:
                    keyboardOffset = frame.minY - offset
                    
                case .willHide, .didHide:
                    keyboardOffset = frame.minY
                }
            }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

public extension View {
    func onKeyboardStatechanged(action: @escaping (OnKeyboardStateChangeModifier.State, CGRect) -> Void) -> some View {
        modifier(OnKeyboardStateChangeModifier(action: action))
    }
    func keyboardAvoidance(offset: CGFloat = 0) -> some View {
        modifier(KeyboardAvoidanceModifier(offset: offset))
    }
}
