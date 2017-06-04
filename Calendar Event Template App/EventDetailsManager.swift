//
//  EventDetailsManager.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/6/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  This handles all the backend data for the Event Details page
//  Helps clean up code

import Foundation
import UIKit
import EventKit // For creating/reading calendar data
import MapKit // For providing location suggestions

extension EventDetails {
    
    // Update location search results
    func updateLocationSearchResults(query: String) {
        let mapSearchRequest = MKLocalSearchRequest()
        mapSearchRequest.naturalLanguageQuery = query
        
        // Simulate current location
        let defaultLocation = DataManager.getLatestLocation() // Get most recent location or default location
        let regionSpan = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        mapSearchRequest.region = MKCoordinateRegion(center: defaultLocation, span: regionSpan) // For providing an area to search
        
        let search = MKLocalSearch(request: mapSearchRequest)
        search.start(completionHandler: { (response, _) in
            guard let response = response else {
                return
            }
            
            var locationResultCount: Int = 10 // Show top x number
            if (locationResultCount > response.mapItems.count) { // If fewer results than max
                locationResultCount = response.mapItems.count // Max is number of responses
            }
            
            var locationResults: [String] = data.meta.category.orderedLocations() // Store suggestions including predictive history
            
            for index in 0..<locationResultCount {
                let mapLocation: MKMapItem = response.mapItems[index] // Current map item
                let readableAddress: String = mapLocation.name! + ", " + self.parseAddress(selectedItem: mapLocation.placemark) // Create human-readable address
                locationResults.append(readableAddress) // Append name
            }
            
            // Populate autocomplete
            if self.locationInput.text! != "" { // If text box has a query
                self.locationInput.updateSuggestions(prioritized: locationResults)
            } else { // If text box empty
                if (!data.meta.noCategory) { // If there is a category
                    self.locationInput.updateSuggestions(prioritized: data.meta.category.orderedLocations())
                }
            }
            
            self.locationInput.updateValid()
        })
    }
    
    // Returns human readable address string
    // Source: https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
    func parseAddress(selectedItem: MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    // Calculate the labels for the quick day picker and update global variables
    func calcQuickDays() {
        let today: Date = Date()
        
        // Date formatter to just get date number
        let dayNumberFormatter = DateFormatter()
        dayNumberFormatter.dateFormat = "d" // Day number ie. '2/1/17' -> '1'
        
        // Date formatter to just get day of week
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "EEE" // 3 letter abbreviation of weekday
        
        let firstTwoStrings: [String] = ["Today", "Tomorrow"] // First two labels
        
        for index in 0..<numQuickDays {
            let currentDate = today.addingTimeInterval(24 * 60 * 60 * Double(index)) // Add x number of days
            
            self.dateOptions[index] = currentDate.dateWithoutTime() // Date value without time of that day
            
            self.dayLabels[index] = dayNumberFormatter.string(from: currentDate) // Set date number
            
            if (index > 1) { // Exclude the first two days
                self.weekdayLabels[index] = dayOfWeekFormatter.string(from: currentDate) // Set day of week
            } else {
                self.weekdayLabels[index] = firstTwoStrings[index] // Set "Today" and "Tomorrow"
            }
        }
    }
    
    func refreshQuickDay() {
        self.calcQuickDays() // Calculate quick days
        
        // Refresh collection view
        DispatchQueue.main.async {
            self.quickDayPicker.reloadData()
        }
    }
    
    func refreshDaysEvents() {
        self.daysEvents = self.calendarManager.getEvents(day: data.event.date.dateWithoutTime())
        
        // Refresh the table
        DispatchQueue.main.async {
            self.eventListTable.reloadData()
        }
    }
    
    func updateDateLabel() {
        // Change frontend label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d" // Format
        self.dateLabel.text = dateFormatter.string(from: data.event.date) + " at" // Update label
    }
}
