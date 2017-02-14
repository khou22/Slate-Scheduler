/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class RootContainerViewController: UIViewController {
    
    fileprivate var rootViewController: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSplashViewController()
    }
    
    /// Does not transition to any other UIViewControllers, SplashViewController only
    func showSplashViewControllerNoPing() {
        
        if rootViewController is SplashViewController {
            return
        }
        
        rootViewController?.willMove(toParentViewController: nil)
        rootViewController?.removeFromParentViewController()
        rootViewController?.view.removeFromSuperview()
        rootViewController?.didMove(toParentViewController: nil)
        
        let splashViewController = SplashViewController(tileViewFileName: Images.submitConfirmation)
        rootViewController = splashViewController
        splashViewController.pulsing = true
        
        splashViewController.willMove(toParentViewController: self)
        addChildViewController(splashViewController)
        view.addSubview(splashViewController.view)
        splashViewController.didMove(toParentViewController: self)
    }
    
    /// Simulates an API handshake success and transitions to MapViewController
    func showSplashViewController() {
        showSplashViewControllerNoPing()
        
    }
    
    
    override var prefersStatusBarHidden : Bool {
        switch rootViewController  {
        case is SplashViewController:
            return true
        default:
            return false
        }
    }
}
