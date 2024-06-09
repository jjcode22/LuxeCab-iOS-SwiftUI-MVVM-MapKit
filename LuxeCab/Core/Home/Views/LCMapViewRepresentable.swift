//
//  LCMapViewRepresentable.swift
//  LuxeCab
//
//  Created by JJMac on 08/06/24.
//

import SwiftUI
import MapKit

struct LCMapViewRepresentable: UIViewRepresentable{
    let mapView = MKMapView()
    let locationManager = LocationManager()
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.isZoomEnabled = true
        mapView.showsUserLocation =  true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let coordinate = locationViewModel.selectedLocationCoordinate{
            print("DEBUG: Selected location in mapView is \(coordinate)")
            
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension LCMapViewRepresentable{
    class MapCoordinator: NSObject, MKMapViewDelegate{
        let parent: LCMapViewRepresentable
        
        init(parent: LCMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        //delegate method for when user updates location
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            parent.mapView.setRegion(region, animated: true)

        }
    }
    
}
