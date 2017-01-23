//
//  OnboardingPager.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/22/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class OnboardingPager: UIPageViewController {
    
    override func viewDidLoad() {
        // Set initial page
        setViewControllers([getPageOne()], direction: .forward, animated: false, completion: nil)
        
        self.dataSource = self // Set data source
        
        // Set background color
        self.view.backgroundColor = Colors.black
    }
    
    func getPageOne() -> OnboardingPageOne {
        // Retrieve the view
        return storyboard!.instantiateViewController(withIdentifier: Storyboard.onboardingPageOne) as! OnboardingPageOne
    }
    
    func getPageTwo() -> OnboardingPageTwo {
        // Retrieve the view
        return storyboard!.instantiateViewController(withIdentifier: Storyboard.onboardingPageTwo) as! OnboardingPageTwo
    }
    
    func getPageThree() -> OnboardingPageThree {
        // Retrieve the view
        return storyboard!.instantiateViewController(withIdentifier: Storyboard.onboardingPageThree) as! OnboardingPageThree
    }
}

extension OnboardingPager: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Swiping forward
        if viewController.isKind(of: OnboardingPageOne.self) { // If you're on page one
            // We want to swipe to page two
            return getPageTwo()
        } else if viewController.isKind(of: OnboardingPageTwo.self) { // If on page two
            // Want page three
            return getPageThree()
        } else { // If on page three
            // End of all pages
            return nil
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Swiping backward
        
        if viewController.isKind(of: OnboardingPageThree.self) {
            // If on page three, can swipe back to page two
            return getPageTwo()
        } else if viewController.isKind(of: OnboardingPageTwo.self) { // If on page two
            // Want page one
            return getPageOne()
        } else {
            // If on the first page, can't swipe back
            return nil
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        // The number of dots in the page control dots
        return 3
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        // On the first dot when you first load the OnboardingPager
        // Swift automatically handles switching pages and updating the page control dots
        // Updates when setViewControllers is called
        return 0
    }
}
