//
//  Event Details Pager.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 6/2/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit

class EventDetailsPager: UIPageViewController {
    
    override func viewDidLoad() {
        // Set initial page
        setViewControllers([getPageOne()], direction: .forward, animated: false, completion: nil)
        
        self.dataSource = self // Set data source
        
        // Set background color
        self.view.backgroundColor = Colors.white
        
    }
    
    func getPageOne() -> EventDetails {
        // Retrieve the view
        return storyboard!.instantiateViewController(withIdentifier: Storyboard.editEventDetails) as! EventDetails
    }
    
    func getPageTwo() -> EventDetailsMore {
        // Retrieve the view
        return storyboard!.instantiateViewController(withIdentifier: Storyboard.editEventDetailsMore) as! EventDetailsMore
    }
}

extension EventDetailsPager: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Swiping forward
        if viewController.isKind(of: EventDetails.self) { // 1 -> 2
            return getPageTwo()
        } else { // If on page two
            return nil
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Swiping backward
        
        if viewController.isKind(of: EventDetailsMore.self) { // 2 -> 1
            return getPageOne()
        } else {
            // If on the first page, can't swipe back
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        // On the first dot when you first load the OnboardingPager
        // Swift automatically handles switching pages and updating the page control dots
        // Updates when setViewControllers is called
        return 0
    }
}
