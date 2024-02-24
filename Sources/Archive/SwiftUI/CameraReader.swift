//
//  CameraReader.swift
//
//
//  Created by jsilver on 2/24/24.
//

import SwiftUI
import AVFoundation

public struct CameraReader: UIViewRepresentable {
    public class Coordinator: CameraReaderViewDelegate {
        // MARK: - Property
        @Binding
        private var isRunning: Bool
        private let onDetect: ([AVMetadataObject]) -> Void
        private let onFail: ((any Error) -> Void)?
        
        // MARK: - Initializer
        init(
            isRunning: Binding<Bool>,
            onDetect: @escaping ([AVMetadataObject]) -> Void,
            onFail: ((any Error) -> Void)?
        ) {
            self._isRunning = isRunning
            self.onDetect = onDetect
            self.onFail = onFail
        }
        
        // MARK: - Lifecycle
        public func cameraReaderView(_ view: CameraReaderView, didDetect metadataObjects: [AVMetadataObject]) {
            onDetect(metadataObjects)
        }
        
        public func cameraReaderView(_ view: CameraReaderView, didFailToStart error: Error) {
            Task { @MainActor in
                isRunning = false
                onFail?(error)
            }
        }
        
        // MARK: - Public
        
        // MARK: - Private
    }
    
    // MARK: - Property
    @Binding
    private var isRunning: Bool
    private let metadataObjectTypes: [AVMetadataObject.ObjectType]
    private let rectOfInterest: CGRect?
    
    private let onDetect: ([AVMetadataObject]) -> Void
    private let onFail: ((any Error) -> Void)?
    
    // MARK: - Initializer
    public init(
        _ isRunning: Binding<Bool>,
        metadataObjectTypes: [AVMetadataObject.ObjectType],
        rectOfInterest: CGRect? = nil,
        onDetect: @escaping ([AVMetadataObject]) -> Void,
        onFail: ((any Error) -> Void)? = nil
    ) {
        self._isRunning = isRunning
        self.metadataObjectTypes = metadataObjectTypes
        self.rectOfInterest = rectOfInterest
        self.onDetect = onDetect
        self.onFail = onFail
    }
    
    // MARK: - Lifecycle
    public func makeUIView(context: Context) -> CameraReaderView {
        let view = CameraReaderView()
        view.delegate = context.coordinator
        
        return view
    }
    
    public func updateUIView(_ uiView: CameraReaderView, context: Context) {
        uiView.metadataObjectTypes = metadataObjectTypes
        uiView.rectOfInterest = rectOfInterest
        
        if isRunning && !uiView.isRunning {
            uiView.start()
        } else if !isRunning && uiView.isRunning {
            uiView.stop()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(isRunning: $isRunning, onDetect: onDetect, onFail: onFail)
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
