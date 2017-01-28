//
//  AppDelegate.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
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
                // Handle shortcut for new uncategorized event
                launchInitialVC(viewController: Storyboard.editEventDetails)
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
        let initialViewController = storyboard.instantiateInitialViewController() as! UINavigationController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        // Perform required segues and navigations
        if (identifier == Storyboard.editEventDetails) { // If launching edit details screen
            initialViewController.pushViewController(storyboard.instantiateViewController(withIdentifier: Storyboard.categorySelection), animated: false)
            let categorySelection = initialViewController.topViewController as! CategorySelection
            categorySelection.newEventNoCategory(self)
        } else if (identifier == Storyboard.onboardingPager) { // If launching onboarding
            let onboardingPager = storyboard.instantiateViewController(withIdentifier: Storyboard.onboardingPager) // Launch onboarding pager as initial vc
            self.window?.rootViewController = onboardingPager
            self.window?.makeKeyAndVisible()
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

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CategoryModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
