//
//  Constants.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    // Project colors
    static let red                          = UIColor(red: 213.0/255.0, green: 73.0/255.0, blue: 31.0/255.0, alpha: 1.0)
    static let orange                       = UIColor(red: 218.0/255.0, green: 141.0/255.0, blue: 15.0/255.0, alpha: 1.0)
    static let green                        = UIColor(red: 128.0/255.0, green: 164.0/255.0, blue: 84.0/255.0, alpha: 1.0)
    static let blue                         = UIColor(red: 50.0/255.0, green: 134.0/255.0, blue: 168.0/255.0, alpha: 1.0)
    static let grey                         = UIColor(red: 157.0/255.0, green: 183.0/255.0, blue: 193.0/255.0, alpha: 1.0)
    static let white                        = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let black                        = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let clear                        = UIColor.clear
}

struct Files {
    // Useful for movie files
}

struct Images {
    // Image names
    static let tabBarFire                   = "white-geo-flame"
}

struct Storyboard {
    // Storyboard identifiers
    static let favorites                    = "favoritesStoryboardScreen"
    static let historyPageOne               = "historyPageOne"
    static let historyPageTwo               = "historyPageTwo"
    static let historyPageThree             = "historyPageThree"
}

struct CellIdentifiers {
    // Table view cell identifiers
    static let settingsCell                 = "SettingsCell"
    
    // Collection view cell identifiers
    static let categoryCell                 = "CategoryCell"
}

struct SegueIdentifiers {
    // Segue identifiers
    static let SettingsToProfile            = "SettingsToProfile"
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
    static let favoriteContacts             = "favoriteContacts"
    
    // Other keys
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
