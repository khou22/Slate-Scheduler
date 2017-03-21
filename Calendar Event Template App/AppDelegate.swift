//
//  AppDelegate.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.initializeLibraries() // Setup any third party libraries/services
        
        let launchedBefore: Bool = Constants.defaults.bool(forKey: Keys.launchedBefore) // If launched app before
        if !launchedBefore { // First launch
            Constants.defaults.set(true, forKey: Keys.launchedBefore) // Update persist data
            Constants.defaults.set(Date(), forKey: Keys.firstLaunchDate) // Set first launch date
            Analytics.firstLaunch() // Log event in GA
        }
        
        // Launch onboarding if user hasn't completed onboarding
        if !DataManager.onboardingStatus() {
            launchInitialVC(viewController: Storyboard.onboardingPager) // Launch onboarding pager as initial vc
        }
        
        // Handle shortcuts
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            _ = handleShortcut(shortcutItem: shortcutItem)
            return false
        }
        
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem: shortcutItem))
    }
    
    // Handle a shortcut
    private func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        switch shortcutItem.type  {
            case "kevinhou.Calendar-Event-Template-App.newUncategorizedEvent":
                Analytics.shortcutCreateNoCategory() // Log event in GA
                
                // Handle shortcut for new uncategorized event
                launchInitialVC(viewController: Storyboard.editEventDetails)
                break
            case "kevinhou.Calendar-Event-Template-App.newCategorizedEvent":
                
                let categoryName = shortcutItem.userInfo?["categoryName"] // Get name of category
                launchInitialVC(viewController: categoryName as! String) // Launch category selection screen
            
                break
            default:
                return false
        }
    
        return true
    }
    
    // Launch a specific screen as initial VC
    private func launchInitialVC(viewController identifier: String) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: Storyboard.rootViewController) as! UINavigationController // Skip splash screen sequence
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        // Perform required segues and navigations
        if (identifier == Storyboard.editEventDetails) { // If launching edit details screen
            
            // New event without category
            initialViewController.pushViewController(storyboard.instantiateViewController(withIdentifier: Storyboard.categorySelection), animated: false)
            let categorySelection = initialViewController.topViewController as! CategorySelection
            categorySelection.withShortcut = true // Used shortcut
            categorySelection.newEventNoCategory(self)
        } else if (identifier == Storyboard.onboardingPager) { // If launching onboarding
            
            // Launch onboarding
            let onboardingPager = storyboard.instantiateViewController(withIdentifier: Storyboard.onboardingPager) // Launch onboarding pager as initial vc
            self.window?.rootViewController = onboardingPager
            self.window?.makeKeyAndVisible()
        } else { // New event with category
            
            // Push category selection
            initialViewController.pushViewController(storyboard.instantiateViewController(withIdentifier: Storyboard.categorySelection), animated: false)
            let categorySelection = initialViewController.topViewController as! CategorySelection
            categorySelection.withShortcut = true // Used shortcut
            
            // Select the category
            let categoryIndex: Int = DataManager.indexForCategory(categoryName: identifier)
            
            if (categoryIndex == -1) { // If category name doesn't exist
                // This should never be reached
                return
            } else { // Category name does exist
                categorySelection.selectedItem = categoryIndex // Set index of category
                categorySelection.categoryData = DataManager.getCategories() // Set categories
                categorySelection.withShortcut = true // Using category
                categorySelection.performSegue(withIdentifier: SegueIdentifiers.createEvent, sender: nil) // Perform segue to event creation page
            }
            
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Setup and initialize any third party libraries
    func initializeLibraries() {
        self.initializeGA() // Set up Google Analytics
    }
    
    // Setup Google Analytics
    func initializeGA() {
        // Configure tracker from GoogleService-Info.plist.
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Configure GAI options.
        guard let gai = GAI.sharedInstance() else { // Check that GAI tracker exists
            assert(false, "Google Analytics not configured correctly")
        }
        gai.trackUncaughtExceptions = true // Report uncaught exceptions
        gai.dispatchInterval = 10.0 // Low dispatch time because time in app should be short
        gai.logger.logLevel = .warning // ONly show errors
//        gai.logger.logLevel = GAILogLevel.verbose // Remove before app release
    }

}

