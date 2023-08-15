//
//  FlexibleTextView.swift
//
//
//  Created by JSilver on 2023/08/14.
//

import UIKit

class FlexibleTextView: UITextView {
    enum Mode {
        case none
        case line(Int)
        case flexible(max: Int)
    }
    
    // MARK: - Property
    var mode: Mode = .none {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    private var estimatedHeight: CGFloat? {
        guard let lineHeight = font?.lineHeight else { return nil }
        
        switch mode {
        case .none:
            return nil
        case let .line(line):
            return lineHeight * CGFloat(line)
        case let .flexible(max: maxLine):
            let max = lineHeight * CGFloat(maxLine)
            let height = text.boundingRect(
                with: CGSize(
                    width: bounds.width - 2 * textContainer.lineFragmentPadding,
                    height: .greatestFiniteMagnitude
                ),
                options: [.usesFontLeading, .usesLineFragmentOrigin],
                attributes: typingAttributes,
                context: nil
            )
                .size
                .height
            
            return min(max > 0 ? max : .infinity, height)
        }
    }
    
    override var font: UIFont? {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var typingAttributes: [NSAttributedString.Key : Any] {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        guard let height = estimatedHeight else { return super.intrinsicContentSize }
        
        return CGSize(
            width: bounds.width,
            height: height + textContainerInset.top + textContainerInset.bottom
        )
    }
    
    // MARK: - Initializer
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        textStorage.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textStorage.delegate = self
    }
}

extension FlexibleTextView: NSTextStorageDelegate {
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        invalidateIntrinsicContentSize()
    }
}
