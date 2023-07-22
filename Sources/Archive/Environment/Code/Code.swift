//
//  Code.swift
//
//
//  Created by jsilver on 2022/01/31.
//

typealias Code = Environment.Code.Code

public extension Environment.Code {
    struct Code: Decodable, Equatable {
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

public extension Environment.Code.Code {
    
}
