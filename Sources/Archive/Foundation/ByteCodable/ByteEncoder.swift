//
//  ByteEncoder.swift
//  
//
//  Created by jsilver on 12/3/23.
//

import Foundation

public enum ByteEncodingError: Error {
    /// 데이터 변환 범위가 데이터 사이즈를 초과한 경우
    case outOfRange
}

public class ByteEncoder {
    // MARK: - Property
    public private(set) var data: Data
    
    // MARK: - Initializer
    public init(capacity: Int = 10) {
        self.data = Data(count: capacity)
    }
    
    // MARK: - Public
    public func data(count: Int? = nil) -> Data {
        guard let count else {
            // 갯수를 지정하지 않는 경우 trailing zero 를 모두 제거
            // 데이터의 후행에서 값이 0 인 영역 얻음
            let offest = data.reversed()
                .firstIndex { $0 != 0 } ?? data.count
            let endIndex = data.index(data.endIndex, offsetBy: -offest)
            
            // Data trailing zero 제거하여 반환
            return data.subdata(in: 0..<endIndex)
        }
        
        guard count <= data.count else {
            // 현재 data 보다 큰 경우 값을 0 으로 채워서 반환
            return data + Data(count: abs(count - data.count))
        }
        
        // 지정한 갯수만큼 data 잘라서 반환
        return data.subdata(in: 0..<count)
    }
    
    public func encode<T>(_ value: T, bytes range: Range<Data.Index>, reversed: Bool = false) throws {
        let capacity = data.count
        guard capacity >= range.upperBound else {
            // 데이터 사이즈 2배로 증가 시킴
            data += Data(count: capacity)
            // 재귀 호출하여 다시 인코딩
            try encode(value, bytes: range, reversed: reversed)
            return
        }
        
        // 인코딩할 값을 Data 로 변환
        var value = value
        let data = Data(withUnsafeBytes(of: &value, { $0 }))
            .subdata(in: 0..<range.upperBound - range.lowerBound)
        
        // Endian 지정 값에 따라 변환
        let formattedData = reversed ? Data(data.reversed()) : data
        
        // 인코딩 데이터에 값을 복사
        self.data.replaceSubrange(range, with: formattedData)
    }
    
    // MARK: - Private
}
