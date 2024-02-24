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
    enum Configuration {
        case develop
        case staging
        case live
        case deploy
    }
    
    static var config: Configuration = .deploy
}
