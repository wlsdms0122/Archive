//
//  UITextFieldView.swift
//
//
//  Created by JSilver on 2023/02/21.
//

import UIKit
import SwiftUI
import Compose

public struct UITextFieldView: UIViewRepresentable {
    public final class Coordinator: NSObject, UITextFieldDelegate {
        // MARK: - Property
        private var inputAccessoryViewCache: ComposableView?
        
        public var onReturn: (() -> Void)?
        private let isEditing: Binding<Bool>?
        
        // MARK: - Initializer
        init(isEditing: Binding<Bool>?) {
            self.isEditing = isEditing
        }
        
        // MARK: - Lifecycle
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            guard !(isEditing?.wrappedValue ?? false) else { return }
            isEditing?.wrappedValue = true
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            guard isEditing?.wrappedValue ?? false else { return }
            isEditing?.wrappedValue = false
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onReturn?()
            return true
        }
        
        // MARK: - Public
        func inputAccessoryView(
            height: CGFloat,
            _ inputAccessoryView: (any View)?
        ) -> UIView? {
            guard let inputAccessoryView else {
                self.inputAccessoryViewCache = nil
                return nil
            }
            
            guard let inputAccessoryViewCache else {
                let composableView = ComposableView(
                    frame: .init(
                        origin: .zero,
                        size: .init(
                            width: 0,
                            height: height
                        )
                    ),
                    disableSafeArea: true,
                    inputAccessoryView
                )
                self.inputAccessoryViewCache = composableView
                
                return composableView
            }
            
            inputAccessoryViewCache.run(inputAccessoryView)
            return inputAccessoryViewCache
        }
        
        // MARK: - Private
    }
    
    // MARK: - Property
    public var placeholder: String?
    public var textColor: UIColor?
    public var tintColor: UIColor?
    public var font: UIFont?
    
    public var isSecureTextEntry: Bool = false
    public var isAutocorrection: Bool = false
    public var isSpellChecking: Bool = false
    public var autocapitalization: UITextAutocapitalizationType = .none
    
    public var keyboardType: UIKeyboardType = .default
    public var returnKeyType: UIReturnKeyType = .default
    
    public var inputAccessoryViewHeight: CGFloat = 0
    public var inputAccessoryView: (any View)? = nil
    
    public var isEditing: Binding<Bool>?
    
    public var onReturn: (() -> Void)?
    
    @Binding
    public var text: String
    
    // MARK: - Initializer
    public init(_ placeholder: String? = nil, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    // MARK: - Lifecycle
    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        view.delegate = context.coordinator
        
        view.addAction(
            UIAction { _ in
                text = view.text ?? ""
            },
            for: [.editingChanged, .valueChanged]
        )
        
        return view
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
        uiView.textColor = textColor
        uiView.tintColor = tintColor
        uiView.font = font
        
        uiView.isSecureTextEntry = isSecureTextEntry
        uiView.autocorrectionType = isAutocorrection ? .yes : .no
        uiView.spellCheckingType = isSpellChecking ? .yes : .no
        uiView.autocapitalizationType = autocapitalization
        
        uiView.keyboardType = keyboardType
        uiView.returnKeyType = returnKeyType
        
        uiView.inputAccessoryView = context.coordinator
            .inputAccessoryView(
                height: inputAccessoryViewHeight,
                inputAccessoryView
            )
        
        context.coordinator.onReturn = onReturn
        
        if (isEditing?.wrappedValue ?? false) && !uiView.isFirstResponder {
            Task {
                uiView.becomeFirstResponder()
            }
        } else if !(isEditing?.wrappedValue ?? false) && uiView.isFirstResponder {
            Task {
                uiView.resignFirstResponder()
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(isEditing: isEditing)
    }
    
    // MARK: - Public
    public func textColor(_ color: UIColor?) -> Self {
        var view = self
        view.textColor = color
        return view
    }
    
    public func tintColor(_ color: UIColor?) -> Self {
        var view = self
        view.tintColor = color
        return view
    }
    
    public func font(_ font: UIFont?) -> Self {
        var view = self
        view.font = font
        return view
    }
    
    public func secureTextEntry(_ isSecureTextEntry: Bool) -> Self {
        var view = self
        view.isSecureTextEntry = isSecureTextEntry
        return view
    }
    
    public func autocorrection(_ isAutocorrection: Bool) -> Self {
        var view = self
        view.isAutocorrection = isAutocorrection
        return view
    }
    
    public func spellChecking(_ isSpellChecking: Bool) -> Self {
        var view = self
        view.isSpellChecking = isSpellChecking
        return view
    }
    
    public func autocapitalization(_ autocapitalization: UITextAutocapitalizationType) -> Self {
        var view = self
        view.autocapitalization = autocapitalization
        return view
    }
    
    public func keyboardType(_ type: UIKeyboardType) -> Self {
        var view = self
        view.keyboardType = type
        return view
    }
    
    public func returnKeyType(_ type: UIReturnKeyType) -> Self {
        var view = self
        view.returnKeyType = type
        return view
    }
    
    public func inputAccessoryView(height: CGFloat = 0, inputAccessoryView: (any View)? = nil) -> Self {
        var view = self
        view.inputAccessoryViewHeight = height
        view.inputAccessoryView = inputAccessoryView
        return view
    }
    
    public func inputAccessoryView(height: CGFloat, @ViewBuilder _ accessoryView: () -> some View) -> Self {
        inputAccessoryView(
            height: height,
            inputAccessoryView: accessoryView()
        )
    }
    
    public func editing(_ isEditing: Binding<Bool>) -> Self {
        var view = self
        view.isEditing = isEditing
        return view
    }
    
    public func onReturn(_ onReturn: @escaping () -> Void) -> Self {
        var view = self
        view.onReturn = onReturn
        return view
    }
    
    // MARK: - Private
}
