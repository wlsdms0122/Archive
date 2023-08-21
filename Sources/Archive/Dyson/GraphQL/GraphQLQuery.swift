//
//  GraphQLQuery.swift
//  
//
//  Created by JSilver on 2023/08/21.
//

import Foundation

struct GraphQLQuery: Encodable {
    struct AnyEncodable: Encodable {
        // MARK: - Property
        let value: Any
        
        // MARK: - Initializer
        init<Value: Encodable>(_ value: Value) {
            self.value = value
        }
        
        // MARK: - Lifecycle
        func encode(to encoder: Swift.Encoder) throws {
            guard let value = value as? Encodable else { return }
            
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    enum CodingKeys: String, CodingKey {
        case query
        case operationName
        case variables
    }
    
    // MARK: - Property
    let query: String
    let operationName: String
    let variables: [String: any Encodable]
    
    // MARK: - Initializer
    init(
        query: String,
        operationName: String = "",
        variables: [String: any Encodable] = [:]
    ) {
        self.query = query
        self.operationName = operationName
        self.variables = variables
        
    }
    
    // MARK: - Lifecycle
    func encode(to encoder: Swift.Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(query, forKey: .query)
        
        if !operationName.isEmpty {
            try container.encode(operationName, forKey: .operationName)
        }
        
        if !variables.isEmpty {
            try container.encode(variables.mapValues { AnyEncodable($0) }, forKey: .variables)
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
