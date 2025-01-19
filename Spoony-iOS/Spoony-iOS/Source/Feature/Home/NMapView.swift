//
//  NMapView.swift
//  Spoony-iOS
//
//  Created by 이지훈 on 1/14/25.
//

import SwiftUI
import NMapsMap

struct NMapView: UIViewRepresentable {
    private let defaultLocation = NMGLatLng(lat: 37.5666102, lng: 126.9783881)
    private let defaultZoomLevel: Double = 15
    private let defaultMarker = NMFOverlayImage(name: "makerTest")
    private let selectedMarker = NMFOverlayImage(name: "makerTestPlain")
    private let defaultMarkerSize = (width: 40.adjusted, height: 58.adjustedH)
    private let selectedMarkerSize = (width: 30.adjusted, height: 30.adjustedH)
    
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = configureMapView(context: context)
        setupInitialCamera(mapView)
        setupMarker(mapView)
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {}
    
    private func configureMapView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        mapView.positionMode = .direction
        mapView.zoomLevel = defaultZoomLevel
        mapView.touchDelegate = context.coordinator
        return mapView
    }
    
    private func setupInitialCamera(_ mapView: NMFMapView) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: defaultLocation)
        mapView.moveCamera(cameraUpdate)
    }
    
    private func setupMarker(_ mapView: NMFMapView) {
        let marker = createMarker(location: defaultLocation)
        marker.mapView = mapView
    }
    
    private func createMarker(location: NMGLatLng) -> NMFMarker {
        let marker = NMFMarker()
        marker.position = location
        marker.iconImage = defaultMarker
        marker.width = CGFloat((NMF_MARKER_SIZE_AUTO))
        marker.height = CGFloat((NMF_MARKER_SIZE_AUTO))
        
        var isSelected = false
        marker.touchHandler = { (_) -> Bool in
            isSelected.toggle()
            if isSelected {
                marker.iconImage = selectedMarker

            } else {
                marker.iconImage = defaultMarker
            }
            return true
        }
        return marker
    }
}

final class Coordinator: NSObject, NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
        return true
    }
}
