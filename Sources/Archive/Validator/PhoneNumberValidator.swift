//
//  PhoneNumberValidator.swift
//  
//
//  Created by jsilver on 2022/01/27.
//

import Foundation

public struct PhoneNumberValidator: Validator {
    // MARK: - Property
    private let validator = RegexValidator(regex: "^\\d{3}-\\d{3,4}-\\d{4}$")
    
    // MARK: - Initializer
    public init() {
        
    }
    
    // MARK: - Public
    public func validate(_ input: String) -> Bool {
        validator.validate(input)
    }
    
    // MARK: - Private
}
