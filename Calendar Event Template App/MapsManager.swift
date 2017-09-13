//
//  MapsManager.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 8/27/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import GooglePlaces

class GooglePlacesManager {
    
    var placesClient: GMSPlacesClient = GMSPlacesClient() // Create client
    var locationBiasing: GMSCoordinateBounds = GMSCoordinateBounds() // Location search biasing
    
    public func setLocationBiasing(location: CLLocationCoordinate2D, radius: Double) {
        let northWest: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude.advanced(by: -radius), longitude: location.longitude.advanced(by: -radius))
        let southEast: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude.advanced(by: radius), longitude: location.longitude.advanced(by: radius))

        self.locationBiasing = GMSCoordinateBounds(coordinate: northWest, coordinate: southEast)
    }
    
    // Get places for certain query
    public func getPlaces(for query: String, completion: @escaping (([String]) -> Void)) {
        var strResults: [String] = []
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        placesClient.autocompleteQuery(query, bounds: self.locationBiasing, filter: filter, callback: {(results, error) -> Void in
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    strResults.append(result.attributedFullText.string)
//                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                }
                completion(strResults) // Callback
            }
        })
    }
}
