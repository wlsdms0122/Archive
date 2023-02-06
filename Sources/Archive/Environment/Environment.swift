//
//  Environment.swift
//
//
//  Created by JSilver on 2023/02/05.
//

import Foundation

public typealias Env = Environment

public enum Environment { }

public extension Environment {
    static var config: Configuration = .deploy
}
