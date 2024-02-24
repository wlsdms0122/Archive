//
//  BackpressureBuffer.swift
//
//
//  Created by jsilver on 2/24/24.
//

import Foundation

class BackpressureBuffer<Data> {
    actor Buffer {
        // MARK: - Property
        private var buffer: [Data] = []
        
        // MARK: - Initializer
        
        // MARK: - Public
        func add(_ data: Data) {
            buffer.append(data)
        }
        
        func clear() -> [Data] {
            let data = buffer
            self.buffer.removeAll()
            
            return data
        }
        
        // MARK: - Private
    }
    
    // MARK: - Property
    private let timeInterval: TimeInterval
    private let consume: @MainActor ([Data]) -> Void
    
    private let buffer = Buffer()
    private var task: Task<Void, any Error>?
    
    // MARK: - Initializer
    init(buffer timeInterval: TimeInterval = 0.1, consume: @escaping ([Data]) -> Void) {
        self.timeInterval = timeInterval
        self.consume = consume
    }
    
    // MARK: - Public
    func emit(_ data: Data) {
        guard task == nil else {
            // Add data into buffer during back pressing.
            Task {
                await buffer.add(data)
            }
            return
        }
        
        task = Task {
            // Add data into buffer to start back pressing.
            await buffer.add(data)
            
            // Sleep task until buffer time interval.
            try await Task.sleep(nanoseconds: UInt64(timeInterval) * 1_000_000_000)
            
            // Clear buffer and consume data and reset back pressing.
            let data = await buffer.clear()
            task = nil
            
            await consume(data)
        }
    }
    
    // MARK: - Private
}
