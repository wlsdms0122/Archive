//
//  ByteDecoder.swift
//
//
//  Created by jsilver on 12/3/23.
//

import Foundation

public enum ByteDecodingError: Error {
    /// 데이터 변환 범위가 데이터 사이즈를 초과한 경우
    case outOfRange
}

public class ByteDecoder {
    // MARK: - Property
    public let data: Data
    
    // MARK: - Initializer
    public init(_ data: Data) {
        self.data = data
    }
    
    // MARK: - Public
    public func decode<T>(of type: T.Type = T.self, bytes range: Range<Data.Index>, reversed: Bool = false) throws -> T {
        guard let data = data[safe: range] else {
            // 데이터 크기를 초과한 범위를 요청한 경우
            throw ByteDecodingError.outOfRange
        }
        
        // 변환 타입의 메모리 사이즈와 비교하여 추가 공간을 할당
        let dataSize = range.upperBound - range.lowerBound
        let size = max(MemoryLayout<T>.size, dataSize)
        
        let formattedData = (reversed ? Data(data.reversed()) : data) + Data(count: size - dataSize)
        
        // Data -> Type 변환
        return formattedData.withUnsafeBytes { pointer in pointer.load(as: type) }
    }
    
    // MARK: - Private
}
