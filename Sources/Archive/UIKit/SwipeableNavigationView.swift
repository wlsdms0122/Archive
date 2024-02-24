//
//  SwipeableNavigationView.swift
//
//
//  Created by jsilver on 2/24/24.
//

import UIKit

public protocol Swipeable { }

final class SwipeableNavigationView: UINavigationController {
    // MARK: - View

    // MARK: - Property
    
    // MARK: - Initializer
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        
    }
    
    private func setUpState() {
        navigationBar.isHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setUpAction() {
        
    }
}

extension SwipeableNavigationView: UIGestureRecognizerDelegate {
    // when a gesture recognizer attempts to transition out of the UIGestureRecognizer.State.possible state
    // Returning false causes the gesture recognizer to transition to the UIGestureRecognizer.State.failed state.
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // prevent interactivePopGesture if view controller is top controller
        return topViewController is Swipeable
    }
    
    // when return false (default is true), gesture recognizer doesn't notified touch event accured
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
}
