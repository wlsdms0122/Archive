//
//  Reactor.swift
//
//
//  Created by JSilver on 2023/02/04.
//

import Foundation
import Combine
import RxSwift

public protocol Flow {
    associatedtype Action
    associatedtype Mutation
    associatedtype State
}

open class Reactor<F: Flow>: ObservableObject {
    public typealias Action = F.Action
    public typealias Mutation = F.Mutation
    public typealias State = F.State
    
    // MARK: - Property
    public let action = PublishSubject<Action>()
    @Published
    public var state: State
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    public init(initialState: State) {
        self.state = initialState
        
        run()
    }
    
    // MARK: - Public
    public func action(_ action: Action) {
        self.action.onNext(action)
    }
    
    open func transform(action: Observable<Action>) -> Observable<Action> {
        action
    }
    
    open func mutate(action: Action) -> Observable<Mutation> {
        .empty()
    }
    
    open func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        mutation
    }
    
    open func reduce(state: State, mutation: Mutation) -> State {
        state
    }
    
    open func transform(state: Observable<State>) -> Observable<State> {
        state
    }
    
    // MARK: - Private
    private func run() {
        let transformedAction = transform(action: action)
        
        let mutation = transformedAction.flatMap { [weak self] action -> Observable<Mutation> in
            guard let self else { return .empty() }
            return self.mutate(action: action)
                .catch { _ in .empty() }
        }
        
        let transformedMutation = transform(mutation: mutation)
        
        let state = transformedMutation.scan(state) { [weak self] state, mutation -> State in
            guard let self else { return state }
            return self.reduce(state: state, mutation: mutation)
        }
            
        let transformedState = transform(state: state)
        
        transformedState.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.state = state
            })
            .disposed(by: disposeBag)
    }
}
