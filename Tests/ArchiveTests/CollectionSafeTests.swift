//
//  CollectionSafeTests.swift
//  
//
//  Created by jsilver on 2022/06/22.
//

import Quick
import Nimble
@testable import Archive

class CollectionSafeTests: QuickSpec {
    override func spec() {
        describe("Array의") {
            context("범위를 벗어난 index 접근을 하면") {
                it("nil이 반환되어야 한다") {
                    // Given
                    let array = [0, 1, 2]
                    
                    // When
                    let result = array[safe: 3]
                    
                    // Then
                    expect(result).to(beNil())
                }
            }
            
            context("범위 안의 index 접근을 하면") {
                it("nil이 반환되지 않아야 한다.") {
                    // Given
                    let array = [0, 1, 2]
                    
                    // When
                    let result = array[safe: 2]
                    
                    // Then
                    expect(result).notTo(beNil())
                }
            }
        }
    }
}
