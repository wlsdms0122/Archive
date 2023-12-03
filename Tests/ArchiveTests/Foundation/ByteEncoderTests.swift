//
//  ByteEncoderTests.swift
//
//
//  Created by jsilver on 12/3/23.
//

import XCTest
@testable import Archive

final class ByteEncoderTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    
    // MARK: - Test
    func test_that_byte_encoder_encode_value() throws {
        // Given
        let encoder = ByteEncoder(capacity: 2)
        
        // When
        try encoder.encode(1, bytes: 0..<1)
        
        // Then
        XCTAssertEqual(encoder.data, Data([1, 0]))
    }
    
    func test_that_byte_encoder_encode_multiple_value() throws {
        // Given
        let encoder = ByteEncoder(capacity: 3)
        
        // When
        try encoder.encode(1, bytes: 0..<1)
        try encoder.encode(2, bytes: 1..<2)
        try encoder.encode(3, bytes: 2..<3)
        
        // Then
        XCTAssertEqual(encoder.data, Data([1, 2, 3]))
    }
    
    func test_that_byte_encoder_encode_override_value() throws {
        // Given
        let encoder = ByteEncoder(capacity: 2)
        
        // When
        // 65,535 = [255, 255] = 2^16
        try encoder.encode(65535, bytes: 0..<2)
        try encoder.encode(100, bytes: 0..<1)
        
        // Then
        XCTAssertEqual(encoder.data, Data([100, 255]))
    }
    
    func test_that_byte_encoder_encode_value_in_long_range() throws {
        // Given
        let encoder = ByteEncoder(capacity: 2)
        
        // When
        try encoder.encode(1, bytes: 0..<4)
        
        // Then
        XCTAssertEqual(encoder.data, Data([1, 0, 0, 0]))
    }
    
    func test_that_byte_encoder_encode_value_in_short_range() throws {
        // Given
        let encoder = ByteEncoder(capacity: 2)
        
        // When
        // 65,535 = [255, 255] = 2^16
        try encoder.encode(65535, bytes: 0..<1)
        
        // Then
        XCTAssertEqual(encoder.data, Data([255, 0]))
    }
    
    func test_that_byte_encoder_expand_capacity_when_value_size_bigger_than_data() throws {
        // Given
        let encoder = ByteEncoder(capacity: 1)
        
        // When
        // 4,294,967,295 = [255, 255, 255, 255] = 2^32
        try encoder.encode(4_294_967_295, bytes: 0..<8)
        
        // Then
        XCTAssertEqual(encoder.data.count, 8)
    }
    
    func test_that_byte_encoder_encode_big_endian_value() throws {
        // Given
        let encoder = ByteEncoder(capacity: 4)
        
        // When
        // 16,776,961 = [1, 255, 255]
        try encoder.encode(16_776_961, bytes: 0..<3, reversed: true)
        
        // Then
        XCTAssertEqual(encoder.data, Data([255, 255, 1, 0]))
    }
    
    func test_that_byte_encoder_encode_big_endian_value_with_partial_range() throws {
        // Given
        let encoder = ByteEncoder(capacity: 4)
        
        // When
        // 16,776,961 = [1, 255, 255]
        try encoder.encode(16_776_961, bytes: 1..<3, reversed: true)
        
        // Then
        XCTAssertEqual(encoder.data, Data([0, 255, 1, 0]))
    }
    
    func test_that_data_removed_trailing_zero_when_get_from_byte_encoder() throws {
        // Given
        let encoder = ByteEncoder(capacity: 4)
        
        // When
        try encoder.encode(1, bytes: 0..<1)
        
        // Then
        XCTAssertEqual(encoder.data(), Data([1]))
    }
    
    func test_that_data_removed_trailing_zero_when_get_full_data_from_byte_encoder() throws {
        // Given
        let encoder = ByteEncoder(capacity: 2)
        
        // When
        // 65,535 = [255, 255]
        try encoder.encode(65_535, bytes: 0..<2)
        
        // Then
        XCTAssertEqual(encoder.data(), Data([255, 255]))
    }
    
    func test_that_data_removed_trailing_zero_when_get_empty_data_from_byte_encoder() throws {
        // Given
        let encoder = ByteEncoder(capacity: 2)
        
        // When
        
        // Then
        XCTAssertEqual(encoder.data(), Data([]))
    }
    
    func test_that_data_when_count_is_specified_will_return_as_much_data_as_count_from_byte_encoder() throws {
        // Given
        let encoder = ByteEncoder(capacity: 2)
        
        // When
        try encoder.encode(255, bytes: 0..<1)
        
        // Then
        XCTAssertEqual(encoder.data(count: 3), Data([255, 0, 0]))
    }
    
    func test_that_data_when_count_is_specified_will_return_as_less_data_as_count_from_byte_encoder() throws {
        // Given
        let encoder = ByteEncoder(capacity: 2)
        
        // When
        try encoder.encode(65_535, bytes: 0..<2)
        
        // Then
        XCTAssertEqual(encoder.data(count: 1), Data([255]))
    }
}
