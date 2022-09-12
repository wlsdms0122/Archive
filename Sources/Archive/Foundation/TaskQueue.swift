//
//  TaskQueue.swift
//  
//
//  Created by jsilver on 2022/09/12.
//

import Foundation

public class TaskQueue {
    // MARK: - Property
    private var tasks: [(_ completion: @escaping () -> Void) -> Void] = []
    
    // MARK: - Initializer
    public init() {
        
    }
    
    // MARK: - Public
    public func addTask(_ task: @escaping (_ completion: @escaping () -> Void) -> Void) {
        tasks.append(task)
    }
    
    public func run(_ completion: (() -> Void)? = nil) {
        guard !tasks.isEmpty else {
            completion?()
            return
        }

        let task = tasks.removeFirst()
        task { [weak self] in
            self?.run(completion)
        }
    }
    
    // MARK: - Private
}
