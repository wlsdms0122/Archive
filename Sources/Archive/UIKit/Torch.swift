//
//  Torch.swift
//
//
//  Created by jsilver on 2/24/24.
//

import Foundation
import AVFoundation

public class Torch {
    // MARK: - Property
    
    // MARK: - Initializer
    
    // MARK: - Public
    public static func on() {
        guard let device = AVCaptureDevice.default(for: .video),
            device.isTorchModeSupported(.on)
        else { return }
        
        do {
            try device.lockForConfiguration()
            
            device.torchMode = .on
            
            device.unlockForConfiguration()
        } catch {
            device.unlockForConfiguration()
        }
    }
    
    public static func off() {
        guard let device = AVCaptureDevice.default(for: .video),
            device.isTorchModeSupported(.off)
        else { return }
        
        do {
            try device.lockForConfiguration()
            
            device.torchMode = .off
            
            device.unlockForConfiguration()
        } catch {
            device.unlockForConfiguration()
        }
    }
    
    public static func auto() {
        guard let device = AVCaptureDevice.default(for: .video),
            device.isTorchModeSupported(.auto)
        else { return }
        
        do {
            try device.lockForConfiguration()
            
            device.torchMode = .auto
            
            device.unlockForConfiguration()
        } catch {
            device.unlockForConfiguration()
        }
    }
    
    // MARK: - Private
}
