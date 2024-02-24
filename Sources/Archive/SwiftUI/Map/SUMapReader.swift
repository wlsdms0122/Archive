//
//  SUMapReader.swift
//
//
//  Created by jsilver on 2/24/24.
//

import Foundation

import SwiftUI
import MapKit

struct SUMapContainerEnvironmentKey: EnvironmentKey {
    static var defaultValue: SUMapContainer?
}

extension EnvironmentValues {
    var suMapContainer: SUMapContainer? {
        get {
            self[SUMapContainerEnvironmentKey.self]
        }
        set {
            self[SUMapContainerEnvironmentKey.self] = newValue
        }
    }
}

public struct SUMapProxy {
    // MARK: - Property
    private let container: SUMapContainer
    private var mapView: MKMapView? { container.mapView }
    
    // MARK: - Initializer
    init(_ container: SUMapContainer) {
        self.container = container
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Public
    public func moveCamera(to region: MKCoordinateRegion, animated: Bool) {
        mapView?.setRegion(region, animated: animated)
    }
    
    // MARK: - Private
}

final class SUMapContainer: ObservableObject {
    // MARK: - Property
    weak var mapView: MKMapView?
    
    // MARK: - Initializer
    init() { }
    
    // MARK: - Public
    
    // MARK: - Private
}

public struct SUMapReader<Content: View>: View {
    // MARK: - View
    public var body: some View {
        content(SUMapProxy(container))
            .environment(\.suMapContainer, container)
    }
    
    // MARK: - Property
    @StateObject
    private var container = SUMapContainer()
    private let content: (SUMapProxy) -> Content
    
    // MARK: - Initializer
    public init(@ViewBuilder content: @escaping (SUMapProxy) -> Content) {
        self.content = content
    }
    
    // MARK: - Public
    
    // MARK: - Private
}
