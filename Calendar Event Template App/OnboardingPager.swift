//
//  OnboardingPager.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/22/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

struct ScrollData {
    // Global variable for percentage scrolled
    static var value: Float = 0.0
    
    // Store which page
    static var previousPage: Int = 0
    static var currentPage: Int = 0
    static func setCurrentPage(index: Int) {
        previousPage = currentPage
        print("Moving from page \(previousPage) to page \(index)")
        currentPage = index
    }
}

class OnboardingPager: UIPageViewController {
    
    override func viewDidLoad() {
        // Set initial page
        setViewControllers([getPageOne()], direction: .forward, animated: false, completion: nil)
        
        self.dataSource = self // Set data source
        
        // Set background color
        self.view.backgroundColor = Colors.black
        
        onboardingBackground()
        
        // Setup scrolling progress delegate
        // Scrolling progress - source: http://stackoverflow.com/questions/22577929/progress-of-uipageviewcontroller
        for subView in view.subviews {
            if subView is UIScrollView {
                (subView as! UIScrollView).delegate = self
                // This allows panning recognition
            }
        }
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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        // On the first dot when you first load the OnboardingPager
        // Swift automatically handles switching pages and updating the page control dots
        // Updates when setViewControllers is called
        return 0
    }
}

// Track the percentage of the scroll complete
extension OnboardingPager: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset // Get pixels offset by scroll
        let percentComplete: CGFloat = fabs(point.x - view.frame.size.width)/view.frame.size.width // Calc percentage complete
//        print("Percentage scrolled \(percentComplete)") // Debugging
        ScrollData.value = Float(percentComplete) // Set global
        
        // Update within the view controllers
        // To prevent glitches, lag, memory management, only use one at a time
        // Use scroll animations for entrance animations only
        switch ScrollData.previousPage {
        case 1:
            getPageOne().updateScrollPercentage()
        case 2:
            getPageTwo().updateScrollPercentage()
        case 3:
            getPageThree().updateScrollPercentage()
        default:
            break
        }

    }
}
