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
    
    // Get places for certain query
    public func getPlaces(for query: String, completion: @escaping (([String]) -> Void)) {
        var strResults: [String] = []
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        placesClient.autocompleteQuery(query, bounds: nil, filter: filter, callback: {(results, error) -> Void in
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
