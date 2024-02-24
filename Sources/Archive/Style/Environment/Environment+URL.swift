//
//  Environment+URL.swift
//
//
//  Created by JSilver on 2023/02/05.
//

import Foundation

public extension Environment {
    enum URL { }
}

public extension Environment.URL {
    static var baseURL: String {
        switch Env.config {
        case .develop:
            return ""
            
        case .staging:
            return ""
            
        case .live:
            return ""
            
        case .deploy:
            return ""
        }
    }
}
