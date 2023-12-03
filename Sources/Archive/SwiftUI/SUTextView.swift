//
//  SUTextView.swift
//
//
//  Created by JSilver on 2023/02/21.
//

import UIKit
import SwiftUI
import Compose
import Validator

public struct SUTextView: UIViewRepresentable {
    public final class Coordinator: NSObject, UITextViewDelegate {
        // MARK: - Property
        @Binding
        var text: String
        
        var validator: (any Validator<String>)?
        private var inputAccessoryViewCache: ComposableView?
        
        private let isEditing: Binding<Bool>?
        
        // MARK: - Initializer
        init(text: Binding<String>, isEditing: Binding<Bool>?) {
            self._text = text
            self.isEditing = isEditing
        }
        
        // MARK: - Lifecycle
        public func textViewDidBeginEditing(_ textView: UITextView) {
            guard !(isEditing?.wrappedValue ?? false) else { return }
            isEditing?.wrappedValue = true
        }
        
        public func textViewDidEndEditing(_ textView: UITextView) {
            guard isEditing?.wrappedValue ?? false else { return }
            isEditing?.wrappedValue = false
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            text = textView.text
        }
        
        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            guard let newString = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) else { return true }
            
            guard !newString.isEmpty else {
                // Empty string always true.
                return true
            }
            
            // Validate new string.
            return validator?.validate(newString) ?? true
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
                
                Task {
                    self.inputAccessoryViewCache = composableView
                }
                
                return composableView
            }
            
            inputAccessoryViewCache.run(inputAccessoryView)
            return inputAccessoryViewCache
        }
        
        // MARK: - Private
    }
    
    // MARK: - Property
    @Binding
    public var text: String
    public var tintColor: UIColor?
    public var textColor: UIColor?
    public var font: UIFont?
    
    public var scrollIndicatorInsets: UIEdgeInsets = .zero
    
    public var isAutocorrection: Bool = false
    public var isSpellChecking: Bool = false
    public var autocapitalization: UITextAutocapitalizationType = .none
    
    public var keyboardType: UIKeyboardType = .default
    public var returnKeyType: UIReturnKeyType = .default
    
    public var inputAccessoryViewHeight: CGFloat = 0
    public var inputAccessoryView: (any View)? = nil
    
    public var validator: (any Validator<String>)?
    
    @OptionalState
    public var isEditing: Bool = false
    
    // MARK: - Initializer
    public init(text: Binding<String>) {
        self._text = text
    }
    
    // MARK: - Lifecycle
    public func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        view.delegate = context.coordinator
        
        view.backgroundColor = .clear
        view.clipsToBounds = false
        
        // Remove horizontal padding.
        view.textContainer.lineFragmentPadding = 0
        // Remote vertical padding.
        view.textContainerInset = .zero
        
        return view
    }
    
    public func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        
        uiView.tintColor = tintColor
        uiView.textColor = textColor
        uiView.font = font
        
        uiView.scrollIndicatorInsets = scrollIndicatorInsets
        
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
        
        context.coordinator.validator = validator
        
        if isEditing && !uiView.isFirstResponder {
            Task {
                uiView.becomeFirstResponder()
            }
        } else if !isEditing && uiView.isFirstResponder {
            Task {
                uiView.resignFirstResponder()
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, isEditing: $isEditing)
    }
    
    // MARK: - Public
    public func tintColor(_ color: UIColor?) -> Self {
        var view = self
        view.tintColor = color
        return view
    }
    
    public func textColor(_ color: UIColor?) -> Self {
        var view = self
        view.textColor = color
        return view
    }
    
    public func font(_ font: UIFont?) -> Self {
        var view = self
        view.font = font
        return view
    }
    
    public func scrollIndicatorInsets(_ insets: UIEdgeInsets) -> Self {
        var view = self
        view.scrollIndicatorInsets = insets
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
    
    public func validator(_ validator: (any Validator<String>)?) -> Self {
        var view = self
        view.validator = validator
        return view
    }
    
    public func editing(_ isEditing: Binding<Bool>) -> Self {
        var view = self
        view._isEditing.bind(isEditing)
        return view
    }
    
    // MARK: - Private
}
