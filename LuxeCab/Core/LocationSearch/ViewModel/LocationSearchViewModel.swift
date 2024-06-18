//
//  LocationSearchViewModel.swift
//  LuxeCab
//
//  Created by JJMac on 08/06/24.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject{
    
    //MARK: - Properties
    
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet{
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    //MARK: - lifecycle
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    //MARK: - helpers
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion){
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("DEBUG: Location search failed with errorr \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else {return}
            let coordinate = item.placemark.coordinate
            self.selectedLocationCoordinate = coordinate
            
            print("DEBUG: Location coordinates \(coordinate)")
        }
    }
    
    //We have to search for the location string in MK
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler){
        //function to get back CLLocationCoordinate2D object which contains the latitude and the longitude for the selected location
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
        
    }
    
    func computeRidePrice(forType type: RideType) -> Double {
        guard let coordinate = selectedLocationCoordinate else {return 0/0}
        guard let userLocationCoordinate = self.userLocation else {return 0.0}
        
        let userLocation = CLLocation(latitude: userLocationCoordinate.latitude, longitude: userLocationCoordinate.longitude)
        
        let destination = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let tripDistanceInMeters = userLocation.distance(from: destination)
        
        return type.computePrice(for: tripDistanceInMeters)
    }
}

//MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
    
}
