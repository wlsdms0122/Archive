//
//  CollectionSafeTests.swift
//  
//
//  Created by jsilver on 2022/06/22.
//

import XCTest
@testable import Archive

final class CollectionSafeTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test
    func test_return_nil_when_access_out_of_range() {
        // Given
        let array = [0, 1, 2]
        
        // When
        let result = array[safe: 3]
        
        // Then
        XCTAssertNil(result)
    }
    
    func test_return_non_nil_when_access_in_range() {
        // Given
        let array = [0, 1, 2]
        
        // When
        let result = array[safe: 2]
        
        // Then
        XCTAssertNotNil(result)
    }
}
