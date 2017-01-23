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
    }
    
    func getPageOne() -> OnboardingPageOne {
        // Retrieve the view
        return storyboard!.instantiateViewController(withIdentifier: Storyboard.onboardingPageOne) as! OnboardingPageOne
    }
    
    func getPageTwo() -> OnboardingPageTwo {
        // Retrieve the view
        return storyboard!.instantiateViewController(withIdentifier: Storyboard.onboardingPageTwo) as! OnboardingPageTwo
    }
}

extension OnboardingPager: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        // Swiping forward
        if viewController.isKind(of: OnboardingPageTwo.self) { // If you're on page one
            // We want to swipe to page two
            return getPageTwo()
        } else { // If on page two
            // End of all pages
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        // Swiping backward
        
        if viewController.isKind(of: OnboardingPageTwo.self) {
            // If on page two, can swipe back to page one
            return getPageOne()
        } else {
            // If on the first page, can't swipe back
            return nil
        }
    }
}
