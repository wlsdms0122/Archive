//
//  SUMap.swift
//  
//
//  Created by jsilver on 2/24/24.
//

import SwiftUI
import MapKit

public struct SUMap: UIViewRepresentable {
    public class Coordinator: NSObject, MKMapViewDelegate {
        // MARK: - Property
        @Binding
        private var region: MKCoordinateRegion
        
        private var overlayContainer: [ObjectIdentifier: MKOverlay] = [:]
        
        // MARK: - Initializer
        init(region: Binding<MKCoordinateRegion>) {
            self._region = region
        }
        
        // MARK: - Lifecycle
        public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            self.region = mapView.region
        }
        
        public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let lineRenderer = MKPolylineRenderer(polyline: polyline)
                lineRenderer.strokeColor = .tintColor
                lineRenderer.lineWidth = 8
                
                return lineRenderer
            }
            
            return MKOverlayRenderer()
        }
        
        // MARK: - Public
        func updateOverlays(_ overlays: [MKOverlay], to mapView: MKMapView) {
            let changes = overlays.difference(from: mapView.overlays) { lhs, rhs in
                ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
            }
            
            changes.forEach { change in
                switch change {
                case let .insert(index, item, _):
                    let id = ObjectIdentifier(item)
                    guard !overlayContainer.keys.contains(id) else {
                        return
                    }
                    
                    overlayContainer[id] = item
                    mapView.insertOverlay(item, at: index)
                    
                case let .remove(_, item, _):
                    let id = ObjectIdentifier(item)
                    guard let overlay = overlayContainer[id] else {
                        return
                    }
                    
                    overlayContainer.removeValue(forKey: id)
                    mapView.removeOverlay(overlay)
                }
            }
        }
        
        // MARK: - Private
    }
    
    @Binding
    private var region: MKCoordinateRegion
    private let showsUserLocation: Bool
    
    private let overlays: [MKOverlay]
    
    public init(
        region: Binding<MKCoordinateRegion>,
        showsUserLocation: Bool = false,
        overlays: [MKOverlay] = []
    ) {
        self._region = region
        self.showsUserLocation = showsUserLocation
        self.overlays = overlays
    }
    
    public func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.region = region
        view.showsUserLocation = showsUserLocation
        
        view.delegate = context.coordinator
        
        return view
    }
    
    public func updateUIView(_ uiView: MKMapView, context: Context) {
        context.environment.suMapContainer?.mapView = uiView
        
        uiView.showsUserLocation = showsUserLocation
        
        context.coordinator.updateOverlays(overlays, to: uiView)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(region: $region)
    }
    
    // MARK: - Public
    
    // MARK: - Private
}

extension MKCoordinateRegion: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.center.latitude == rhs.center.longitude
            && lhs.center.longitude == rhs.center.latitude
            && lhs.span.latitudeDelta == rhs.span.latitudeDelta
            && lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}
