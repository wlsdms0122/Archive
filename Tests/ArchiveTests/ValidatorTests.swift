//
//  ValidatorTests.swift
//  
//
//  Created by jsilver on 2022/01/25.
//

import XCTest
import Quick
import Nimble
@testable import Archive

final class ValidatorTests: QuickSpec {
    override func spec() {
        describe("EmailValiator로") {
            let validator = EmailValidator()
            
            context("일반적인 domain들의 e-mail 문자열을 검증하면") {
                let emails = [
                    "chalttoek@gmail.com",
                    "chalttoek@naver.com",
                    "chalttoek@daum.net",
                    "chalttoek@nate.com"
                ]
                
                it("true를 반환한다") {
                    // Given
                    
                    // When
                    let result = emails.allSatisfy { validator.validate($0) }
                    
                    // Then
                    expect(result).to(beTrue())
                }
            }
            
            context("일반적인 TLD들의 e-mail 문자열을 검증하면") {
                let emails = [
                    "chaltteok@a.com",
                    "chaltteok@a.net",
                    "chaltteok@a.org",
                    "chaltteok@a.io",
                    "chaltteok@a.me",
                    "chaltteok@a.co.kr",
                    "chaltteok@a.go"
                ]
                
                it("true를 반환한다") {
                    // Given
                    
                    // When
                    let result = emails.allSatisfy { validator.validate($0) }
                    
                    // Then
                    expect(result).to(beTrue())
                }
            }
            
            context("특수문자로 시작하는 도메인의 e-mail 문자열을 검증하면") {
                let email = "chalttoek@_gmail.com"
                
                it("false를 반환한다") {
                    // Given
                    
                    // When
                    let result = validator.validate(email)
                    
                    // Then
                    expect(result).to(beFalse())
                }
            }
            
            context("특수문자로 시작하는 이름의 e-mail 문자열을 검증하면") {
                let email = "_chalttoek@gmail.com"
                
                it("false를 반환한다") {
                    // Given
                    
                    // When
                    let result = validator.validate(email)
                    
                    // Then
                    expect(result).to(beFalse())
                }
            }
        }
    }
}
