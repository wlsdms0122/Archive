//
//  RevisionTests.swift
//  
//
//  Created by jsilver on 2021/06/27.
//

import XCTest
@testable import Archive

final class RevisionTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test
    func test_revision_increased_when_assign_value() {
        // Given
        @Revision
        var revisionValue: Int = 0
        
        let revision = $revisionValue.revision
        
        // When
        revisionValue = 1
        
        // Then
        XCTAssertEqual(revision, 0)
        XCTAssertEqual($revisionValue.revision, 1)
    }
    
    func test_revision_increased_when_assign_same_value() {
        // Given
        @Revision
        var revisionValue: Int = 0
        let origin = $revisionValue
        
        // When
        revisionValue = 0
        
        // Then
        XCTAssertNotEqual(origin, $revisionValue)
    }
}
