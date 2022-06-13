//
//  PublishedReactorTests.swift
//  
//
//  Created by jsilver on 2022/06/13.
//

import XCTest
import Quick
import Nimble
import ReactorKit
import Combine
@testable import Archive

final class TestReactor: Reactor {
    enum Action {
        case increase
    }
    
    enum Muatation {
        case increase
    }
    
    struct State {
        var count: Int
    }
    
    // MARK: - Property
    var initialState: State
    
    // MARK: - Initializer
    init() {
        initialState = State(count: 0)
    }
    
    // MARK: - Lifecycle
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .increase:
            return .just(.increase)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        var state = state
        
        switch mutation {
        case .increase:
            state.count = state.count + 1
            return state
        }
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

final class PublishedReactorTests: QuickSpec {
    override func spec() {
        describe("PublishedReactor에") {
            context("Action을 보내면") {
                it("상태가 바뀌어야한다.") {                    
                    waitUntil { done in
                        Task {
                            // Given
                            let reactor = TestReactor().publisher
                            let expectation = [0, 1]
                            var cancellable: AnyCancellable?
                            
                            let result: [Int] = await withUnsafeContinuation { continuation in
                                cancellable = reactor.$state.map(\.count)
                                    .removeDuplicates()
                                    .collect(expectation.count)
                                    .sink { continuation.resume(returning: $0) }
                                
                                // When
                                reactor.action.send(.increase)
                            }
                            cancellable?.cancel()
                            
                            // Then
                            expect(result).to(equal(expectation))
                            done()
                        }
                    }
                }
            }
        }
    }
}
