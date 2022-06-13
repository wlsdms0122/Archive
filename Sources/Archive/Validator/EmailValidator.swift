//
//  FiEmailValidatorle.swift
//  
//
//  Created by jsilver on 2022/01/27.
//

import Foundation

public struct EmailValidator: Validator {
    // MARK: - Property
    private let validator = RegexValidator(regex: "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$")
    
    // MARK: - Initializer
    public init() {
        
    }
    
    // MARK: - Public
    public func validate(_ input: String) -> Bool {
        validator.validate(input)
    }
    
    // MARK: - Private
}
