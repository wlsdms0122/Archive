//
//  TaskTimeoutTests.swift
//
//
//  Created by jsilver on 12/2/23.
//

import Foundation
@testable import Archive
import XCTest

class TaskTimeoutTests: XCTestCase {
    // MARK: - Property
    
    // MARK: - Lifecycle
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Test
    func test_that_task_should_return_value_before_timeout() async throws {
        // Given
        let result = try await Task.timeout(4) {
            try await heavyTask(2, .success(10))
        }
        
        // When
        
        // Then
        XCTAssertEqual(result, 10)
    }
    
    func test_that_task_throw_timeout_error_when_does_not_return_value_before_timeout() async throws {
        do {
            // Given
            
            // When
            _ = try await Task.timeout(2) {
                try await heavyTask(4, .success(10))
            }
            
            XCTFail()
        } catch {
            // Then
            XCTAssertTrue(error is TimeoutError)
        }
    }
    
    func test_that_task_throw_error_when_operation_throw_error_before_timeout() async throws {
        do {
            // Given
            
            // When
            let _: Void = try await Task.timeout(4) {
                try await heavyTask(2, .failure(TaskTimeoutTestError(code: "inner error")))
            }
            
            XCTFail()
        } catch let error as TaskTimeoutTestError {
            // Then
            XCTAssertTrue(error == TaskTimeoutTestError(code: "inner error"))
        } catch {
            XCTFail()
        }
    }
}

private struct TaskTimeoutTestError: Error, Equatable {
    let code: String
    
    init(code: String) {
        self.code = code
    }
}

private func heavyTask<T>(_ interval: TimeInterval, _ `return`: Result<T, any Error>) async throws -> T {
    try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
    
    switch `return` {
    case let .success(result):
        return result
        
    case let .failure(error):
        throw error
    }
}
