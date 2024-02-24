//
//  CameraAuthorizable.swift
//
//
//  Created by jsilver on 2/24/24.
//

import Foundation
import AVFoundation
import Combine

public protocol CameraAuthorizable {
    /// 카메라 권한 상태
    func authorization(for mediaType: AVMediaType) -> AVAuthorizationStatus
    func authorizationPublisher(for mediaType: AVMediaType) -> AnyPublisher<AVAuthorizationStatus, Never>
    
    /// 카메라 권한 상태 확인
    func checkAuthorization(for mediaType: AVMediaType) async throws -> AVAuthorizationStatus
    /// 카메라 권한 요청
    func requestAuthorization(for mediaType: AVMediaType)
}

public class CameraAuthorizator: CameraAuthorizable {
    // MARK: - Property
    private var authorizationContinuation: CheckedContinuation<AVAuthorizationStatus, Never>?
    private let authorizationPublisher = PassthroughSubject<(AVMediaType, AVAuthorizationStatus), Never>()
    
    // MARK: - Initializer
    public init() { }
    
    // MARK: - Public
    public func authorization(for mediaType: AVMediaType) -> AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: mediaType)
    }
    
    public func checkAuthorization(for mediaType: AVMediaType) async throws -> AVAuthorizationStatus {
        let status = authorization(for: mediaType)
        guard status == .notDetermined else { return status }
        
        let container = SendableContainer<AnyCancellable?>()
        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                Task {
                    await container.set(
                        authorizationPublisher(for: mediaType).filter { state in state != .notDetermined }
                            .first()
                            .handleEvents(receiveCancel: {
                                continuation.resume(throwing: CancellationError())
                            })
                            .sink { state in
                                continuation.resume(returning: state)
                            }
                    )
                    
                    requestAuthorization(for: mediaType)
                }
            }
        } onCancel: {
            Task {
                await container.value?.cancel()
            }
        }
    }
    
    public func requestAuthorization(for mediaType: AVMediaType) {
        AVCaptureDevice.requestAccess(for: mediaType) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.authorizationPublisher.send((mediaType, self.authorization(for: mediaType)))
            }
        }
    }
    
    public func authorizationPublisher(for mediaType: AVMediaType) -> AnyPublisher<AVAuthorizationStatus, Never> {
        authorizationPublisher.filter { type, _ in type == mediaType }
            .map { _, authorization in authorization }
            .prepend(authorization(for: mediaType))
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
}
