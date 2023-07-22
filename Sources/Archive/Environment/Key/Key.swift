//
//  Key.swift
//
//
//  Created by JSilver on 2023/03/30.
//

import Foundation

public typealias Key = Environment.Key.Key

public extension Environment.Key {
    struct Key: Decodable, Equatable {
        // MARK: - Property
        public let rawValue: String
        public let description: String?
        
        // MARK: - Initializer
        public init(_ rawValue: String, description: String? = nil) {
            self.rawValue = rawValue
            self.description = description
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            let code = try container.decode(String.self)
            
            self.init(code)
        }
        
        // MARK: - Public
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue == rhs.rawValue
        }
        
        // MARK: - Private
    }
}

public extension Environment.Key.Key {
    
}
