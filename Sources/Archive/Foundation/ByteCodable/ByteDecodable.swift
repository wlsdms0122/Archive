//
//  ByteDecodable.swift
//
//
//  Created by jsilver on 12/3/23.
//

import Foundation

public protocol ByteDecodable {
    init(from decoder: ByteDecoder) throws
}

public extension ByteDecodable {
    init(_ data: Data) throws {
        try self.init(from: ByteDecoder(data))
    }
}
