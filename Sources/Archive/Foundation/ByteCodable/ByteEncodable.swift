//
//  ByteEncodable.swift
//
//
//  Created by jsilver on 12/3/23.
//

import Foundation

public protocol ByteEncodable {
    func encode(to encoder: ByteEncoder) throws
}

public extension ByteEncodable {
    func data(count: Int? = nil) throws -> Data {
        let encoder = ByteEncoder()
        
        try encode(to: encoder)
        
        return encoder.data(count: count)
    }
}
