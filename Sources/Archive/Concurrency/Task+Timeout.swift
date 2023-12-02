//
//  Task+Timeout.swift
//
//
//  Created by jsilver on 12/2/23.
//

import Foundation

public struct TimeoutError: CustomStringConvertible, Error {
    public let description: String
    
    init(_ message: String) {
        self.description = message
    }
}

public extension Task where Failure == Error {
    static func timeout(
        _ timeout: TimeInterval,
        operation: @escaping () async throws -> Success
    ) async throws -> Success {
        try await withThrowingTaskGroup(of: Success.self) { group in
            group.addTask {
                try await operation()
            }
            
            group.addTask {
                try await Task<Never, Never>.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                throw TimeoutError("The operation exceeded the \(timeout) second timeout.")
            }
            
            guard let result = try await group.next() else {
                throw _Concurrency.CancellationError()
            }
            
            group.cancelAll()
            
            return result
        }
    }
}
