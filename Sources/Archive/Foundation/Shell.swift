//
//  Shell.swift
//
//
//  Created by mackey on 2022/11/03.
//

import Foundation

#if os(macOS)
@discardableResult
func shell(_ command: String) throws -> String? {
    let process = Process()
    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe
    process.executableURL = URL(fileURLWithPath: "/bin/zsh")
    
    process.arguments = [
        "-c",
        command
    ]
    
    try process.run()
    process.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8)
}

func shell(_ commands: String...) throws {
    try shell(commands.joined(separator: " "))
}
#endif
