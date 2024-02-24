//
//  CameraReaderView.swift
//
//
//  Created by jsilver on 2/24/24.
//

import UIKit
import AVFoundation

public protocol CameraReaderViewDelegate: AnyObject {
    func cameraReaderView(_ view: CameraReaderView, didDetect metadataObjects: [AVMetadataObject])
    func cameraReaderView(_ view: CameraReaderView, didFailToStart error: any Error)
}

public final class CameraReaderView: UIView {
    private static let DEFAULT_RECT_OF_INTEREST = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
    
    // MARK: - View
    
    // MARK: - Property
    public var isRunning: Bool { captureSession.isRunning }
    
    public var metadataObjectTypes: [AVMetadataObject.ObjectType]? {
        didSet {
            overatingQueue.async { [weak self] in
                self?.output?.metadataObjectTypes = self?.metadataObjectTypes ?? []
            }
        }
    }
    public var rectOfInterest: CGRect? {
        didSet {
            output?.rectOfInterest = convertToRectOfIntrest(rectOfInterest)
        }
    }
    
    private let cameraAuthoriztor: CameraAuthorizable = CameraAuthorizator()
    
    private let captureSession = AVCaptureSession()
    private var input: AVCaptureDeviceInput?
    private var output: AVCaptureMetadataOutput?
    
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    weak var delegate: (any CameraReaderViewDelegate)?
    
    private let overatingQueue = DispatchQueue(label: "com.willog.camera-reader")
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    // MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        previewLayer.frame = bounds
        output?.rectOfInterest = convertToRectOfIntrest(rectOfInterest)
    }
    
    // MARK: - Public
    public func start() {
        guard cameraAuthoriztor.authorization(for: .video) == .authorized else {
            // Not authorized.
            self.delegate?.cameraReaderView(self, didFailToStart: CameraReaderError.notAuthorized)
            return
        }
        
        guard !captureSession.isRunning else {
            // Already running.
            return
        }
        
        overatingQueue.async { [weak self] in
            guard let self else { return }
            
            do {
                // Set up capture device input & output.
                try self.setUpInput()
                try self.setUpOutput()
                
                // Start capture.
                self.captureSession.startRunning()
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.delegate?.cameraReaderView(self, didFailToStart: error)
                }
            }
        }
    }
    
    public func stop() {
        guard captureSession.isRunning else {
            // Not running.
            return
        }
        
        overatingQueue.async { [weak self] in
            // Stop capture.
            self?.captureSession.stopRunning()
        }
    }
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpState()
        setUpAction()
    }
    
    private func setUpLayout() {
        layer.addSublayer(previewLayer)
        previewLayer.frame = bounds
    }
    
    private func setUpState() {
        previewLayer.session = captureSession
        previewLayer.videoGravity = .resizeAspectFill
    }
    
    private func setUpAction() {
        
    }
    
    private func setUpInput() throws {
        guard input == nil else {
            // Already input added.
            return
        }
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            // Not exsit available capture device.
            throw CameraReaderError.deviceNotExist
        }
        
        let input = try AVCaptureDeviceInput(device: captureDevice)
        guard captureSession.canAddInput(input) else {
            // Can't add capture device input.
            throw CameraReaderError.unknown
        }
        
        // Add input.
        captureSession.addInput(input)
        
        self.input = input
    }
    
    private func setUpOutput() throws {
        guard output == nil else {
            // Already output added.
            return
        }
        
        let output = AVCaptureMetadataOutput()
        
        guard captureSession.canAddOutput(output) else {
            // Can't add capture device output.
            throw CameraReaderError.unknown
        }
        
        // Add output.
        captureSession.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = metadataObjectTypes ?? []
        output.rectOfInterest = convertToRectOfIntrest(rectOfInterest)
        
        self.output = output
    }
    
    private func convertToRectOfIntrest(_ rect: CGRect?) -> CGRect {
        guard let rect else { return CameraReaderView.DEFAULT_RECT_OF_INTEREST }
        // Calculate POI rect.
        return previewLayer.metadataOutputRectConverted(fromLayerRect: rect)
    }
}

extension CameraReaderView: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        delegate?.cameraReaderView(self, didDetect: metadataObjects)
    }
}
