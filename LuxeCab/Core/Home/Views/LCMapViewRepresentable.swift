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
            context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            
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
        var userLocationCoordinate: CLLocationCoordinate2D?
        
        //MARK: - lifecycle
        init(parent: LCMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        //delegate method for when user updates location
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            guard !parent.isUserInteracting else { return }
            
            self.userLocationCoordinate = userLocation.coordinate
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            parent.mapView.setRegion(region, animated: true)

        }
        
        //delegate method to tell the mapViewDelegate to draw an overlay using a renderer object
        func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
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
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D){
            guard let userLocationCoordinate = self.userLocationCoordinate else {return}
            getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                self.parent.mapView.addOverlay(route.polyline)
                
            }
        }
        
        
        func getDestinationRoute(from userLocation: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D, completion: @escaping(MKRoute) -> Void){
            let userPlacemark = MKPlacemark(coordinate: userLocation)
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
            let request = MKDirections.Request()
            
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destinationPlacemark)
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let error = error {
                    print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                    return
                }
                
                guard let route = response?.routes.first else {return}
                completion(route)
            }
        }
    }
    
}
