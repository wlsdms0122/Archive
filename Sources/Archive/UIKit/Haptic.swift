//
//  Haptic.swift
//
//
//  Created by JSilver on 2023/07/14.
//

import UIKit
import CoreHaptics

public class Haptic {
    // MARK: - Property
    public static let shared: Haptic = Haptic()
    
    private var engine: CHHapticEngine?
    
    // MARK: - Initializer
    private init() { 
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let engine = try? CHHapticEngine()
        engine?.isAutoShutdownEnabled = true
        
        self.engine = engine
    }
    
    // MARK: - Public
    public func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    public func impact(pattern: CHHapticPattern, at time: TimeInterval = CHHapticTimeImmediate) {
        try? engine?.makePlayer(with: pattern)
            .start(atTime: time)
    }
    
    // MARK: - Private
}
