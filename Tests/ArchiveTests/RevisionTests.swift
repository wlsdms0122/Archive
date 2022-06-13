//
//  RevisionTests.swift
//  
//
//  Created by jsilver on 2021/06/27.
//

import XCTest
import Quick
import Nimble
@testable import Archive

final class RevisionTests: QuickSpec {
    override func spec() {
        describe("@Revision에") {
            context("값을 할당하면") {
                it("revision이 1 증가해야한다") {
                    // Given
                    @Revision
                    var revisionValue: Int = 0
                    let revision = $revisionValue.revision
                    
                    // When
                    revisionValue = 1
                    
                    // Then
                    expect(revision).to(equal(0))
                    expect($revisionValue.revision).to(equal(1))
                }
            }
            
            context("동일한 값을 할당하면") {
                it("같지 않아야한다") {
                    // Given
                    @Revision
                    var revisionValue: Int = 0
                    let origin = $revisionValue
                    
                    // When
                    revisionValue = 0
                    
                    // Then
                    expect(origin).notTo(equal($revisionValue))
                }
            }
        }
    }
}
