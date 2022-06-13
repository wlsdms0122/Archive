//
//  PublishedReactor.swift
//  
//
//  Created by jsilver on 2022/06/13.
//

import Combine
import RxSwift
import ReactorKit

public final class PublishedReactor<R: Reactor>: ObservableObject {
    public let action = PassthroughSubject<R.Action, Never>()
    
    @Published
    public private(set) var state: R.State
    
    private var stateDisposable: Disposable? {
        didSet {
            oldValue?.dispose()
        }
    }
    private var actionCancellable: AnyCancellable?
    
    public init(_ reactor: R) {
        _state = .init(initialValue: reactor.initialState)
        
        // State
        stateDisposable = reactor.state
            .subscribe(onNext: { [weak self] in self?.state = $0 })
        
        // Action
        actionCancellable = action.sink { reactor.action.onNext($0) }
    }
}

public extension Reactor {
    var publisher: PublishedReactor<Self> {
        get {
            PublishedReactor(self)
        }
        set { }
    }
}
