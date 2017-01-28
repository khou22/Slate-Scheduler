//
//  Constants.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

struct StringIdentifiers {
    static let noCategory                   = "!#No#Category#!" // To signify a new event with no category
}

struct Colors {
    // Project colors
    static let red                          = UIColor(red: 226.0/255.0, green: 111.0/255.0, blue: 80.0/255.0, alpha: 1.0) // Custom color scheme
    static let lightRed                     = UIColor(red: 238.0/255.0, green: 189.0/255.0, blue: 175.0/255.0, alpha: 1.0) // Custom color scheme - light version
    static let orange                       = UIColor(red: 218.0/255.0, green: 141.0/255.0, blue: 15.0/255.0, alpha: 1.0)
    static let green                        = UIColor(red: 128.0/255.0, green: 164.0/255.0, blue: 84.0/255.0, alpha: 1.0)
    static let blue                         = UIColor(red: 0.0/255.0, green: 118.0/255.0, blue: 255.0/255.0, alpha: 1.0) // iOS default blue
    static let lightGrey                    = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0) // Light grey form labels
    static let grey                         = UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1.0) // Summary card background
    static let white                        = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let black                        = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let clear                        = UIColor.clear
}

struct Gradients {
    // Project gradients
    
}

struct Files {
    // Useful for movie files
}

struct Images {
    // Image names
    static let calendarIcon                 = "calendar-icon"
    static let submitConfirmation           = "submit-confirmation"
    static let eventSummaryCard             = "event-summary-card"
    static let eventSummaryCardNoCategory   = "event-summary-card-no-category"
    static let eventSummaryCardAlt1         = "event-summary-card-alt-1"
    static let eventSummaryCardAlt2         = "event-summary-card-alt-2"
}

struct Storyboard {
    // Storyboard identifiers
    static let categorySelection            = "categorySelection"
    static let editEventDetails             = "editNewEventDetails"
    
    // Onboarding identifiers
    static let onboardingPager              = "OnboardingPager"
    static let onboardingPageOne            = "OnboardingPageOne"
    static let onboardingPageTwo            = "OnboardingPageTwo"
    static let onboardingPageThree          = "OnboardingPageThree"
}

struct CellIdentifiers {
    // Table view cell identifiers
    static let eventListCell                = "EventListCell"
    static let categoryEditCell             = "CategoryEditCell"
    static let nameLocationCell             = "NameLocationCell"
    static let autcompleteCell              = "AutcompleteCell"
    
    // Collection view cell identifiers
    static let categoryCell                 = "CategoryCell"
    static let quickDayCell                 = "QuickDayPickerCell"
}

struct SegueIdentifiers {
    // Segue identifiers
    static let createEvent                  = "CategoryToEventDetail"
    static let editCategories               = "CategorySelectionToEdit"
    static let categoryDetailEdit           = "CategoryDetailEdit"
    static let newEventNoCategory           = "NewEventNoCategory"
    static let completeOnboarding           = "CompleteOnboarding"
}

struct SDK {
    // SDK Keys
    static let sdkAppID                     = "random"
}

struct Constants {
    // NSUserDefaults initializer
    static let defaults                     = UserDefaults.standard
}

struct Keys {
    // NSUserDefault keys:
    static let categoryData                 = "categoryData"
    static let completedOnboarding          = "completedOnboarding"
    static let categoryLabelOnEvents        = "categoryLabelOnEvents"
    
    // Other keys
    static let categoryName                 = "categoryName"
    static let eventNameFreq                = "nameFrequency"
    static let eventNameToLocation          = "eventNameToLocation"
}

struct Urls {
    // URLs
    static let personalWebsite              = "https://khou22.github.io"
}

struct ScreenSize {
    // Phone screen size
    static let screen_width                 = UIScreen.main.bounds.size.width
    static let screen_height                = UIScreen.main.bounds.size.height
    static let screen_max_length            = max(ScreenSize.screen_width, ScreenSize.screen_height)
    static let screen_min_length            = min(ScreenSize.screen_width, ScreenSize.screen_height)
}

struct DeviceTypes {
    // Device type (useful for constraints)
    static let iPhone4                      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screen_max_length < 568.0
    static let iPhone5                      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screen_max_length == 568.0
    static let iPhone6Standard              = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screen_max_length == 667.0 && UIScreen.main.nativeScale == UIScreen.main.scale
    static let iPhone6Zoomed                = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screen_max_length == 667.0 && UIScreen.main.nativeScale > UIScreen.main.scale
    static let iPhone6PlusStandard          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screen_max_length == 736.0
    static let iPhone6PlusZoomed            = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screen_max_length == 736.0 && UIScreen.main.nativeScale < UIScreen.main.scale
    static let iPad                         = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.screen_max_length == 1024.0
}
