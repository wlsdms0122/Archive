//
//  ByteDecoderTests.swift
//
//
//  Created by jsilver on 12/3/23.
//

import XCTest
@testable import Archive

final class ByteDecoderTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    
    // MARK: - Test
    func test_that_byte_decoder_decode_when_decode_range_less_than_a_type() throws {
        // Given
        // Little endian data (10 byte)
        let data = Data([1, 0, 0, 0, 0, 0, 0, 0, 0, 0])
        let decoder = ByteDecoder(data)
        
        // When
        // Memory size(Int64) : 8 byte
        // Decode range       : 2 byte
        let result = try decoder.decode(of: Int64.self, bytes: 0..<2)
        
        // Then
        XCTAssertEqual(result, 1)
    }
    
    func test_that_byte_decoder_decode_when_decode_range_greater_than_a_type() throws {
        // Given
        // Little endian data (10 byte)
        let data = Data([1, 0, 0, 0, 0, 0, 0, 0, 0, 0])
        let decoder = ByteDecoder(data)
        
        // When
        // Memory size(Int64) : 8 byte
        // Decode range       : 10 byte
        let result = try decoder.decode(of: Int64.self, bytes: 0..<10)
        
        // Then
        XCTAssertEqual(result, 1)
    }
    
    func test_that_byte_decoder_decode_when_decode_reversed_data() throws {
        // Given
        // Little endian data (10 byte)
        let data = Data([1, 0, 0, 0, 0, 0, 0, 0, 0, 0])
        let decoder = ByteDecoder(data)
        
        // When
        // Memory size(Int64) : 8 byte
        // Decode range       : 2 byte
        let result = try decoder.decode(of: Int64.self, bytes: 0..<2, reversed: true)
        
        // Then
        XCTAssertEqual(result, 256)
    }
    
    func test_that_byte_decoder_throw_error_when_decode_range_greater_than_given_data() throws {
        // Given
        // Little endian data (4 byte)
        let data = Data([1, 0, 0, 0])
        let decoder = ByteDecoder(data)
        
        // When
        // Memory size(Int64) : 8 byte
        // Decode range       : 8 byte
        XCTAssertThrowsError(try decoder.decode(of: Int64.self, bytes: 0..<8))
        
        // Then
    }
}
