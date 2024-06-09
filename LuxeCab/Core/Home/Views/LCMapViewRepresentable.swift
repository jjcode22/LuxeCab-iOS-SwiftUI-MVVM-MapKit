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
    @State private var isUserInteracting = false
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.isZoomEnabled = true
        mapView.showsUserLocation =  true
        mapView.userTrackingMode = .follow
        
        // Track user interaction to prevent unwanted map resets
        mapView.addGestureRecognizer(UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleMapPan)))
        mapView.addGestureRecognizer(UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleMapPinch)))
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let coordinate = locationViewModel.selectedLocationCoordinate{
            context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
            
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension LCMapViewRepresentable{
    class MapCoordinator: NSObject, MKMapViewDelegate{
        //MARK: - properties
        let parent: LCMapViewRepresentable
        
        //MARK: - lifecycle
        init(parent: LCMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        //delegate method for when user updates location
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            guard !parent.isUserInteracting else { return }
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            parent.mapView.setRegion(region, animated: true)

        }
        
        @objc func handleMapPan() {
            parent.isUserInteracting = true
        }

        @objc func handleMapPinch() {
            parent.isUserInteracting = true
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.isUserInteracting = false
        }

        
        //MARK: - helpers
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D){
            //remove previous annotations
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapView.addAnnotation(anno)
            parent.mapView.selectAnnotation(anno, animated: true)
            
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
    }
    
}
