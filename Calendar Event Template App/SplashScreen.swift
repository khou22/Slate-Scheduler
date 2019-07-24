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

open class SplashViewController: UIViewController {
    open var pulsing: Bool = false
    
    var animatedLogo: UIImageView!
    var tileGridView: TileGridView!
    
    public init(tileViewFileName: String) {
        
        super.init(nibName: nil, bundle: nil)
        
        // Setup grid
        tileGridView = TileGridView(TileFileName: Images.tilePattern)
        view.addSubview(tileGridView)
        tileGridView.frame = view.bounds
        
        // Setup logo
        animatedLogo = UIImageView() // Set icon
        if let image = UIImage(named: Images.calendarIcon) {
            animatedLogo.image = image // Set image
            animatedLogo.contentMode = .scaleAspectFit // Aspect fit
        }
        view.addSubview(animatedLogo)
        let logoWidth: CGFloat = 90.0
        let logoHeight: CGFloat = 100.0
        let origin = CGPoint(x: (view.frame.width - logoWidth) / 2, y: (view.frame.height - logoHeight) / 2)
        animatedLogo.frame = CGRect(origin: origin, size: CGSize(width: 90.0, height: 90.0))
        
        tileGridView.startAnimating()
        animateLogo()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func animateLogo() {
        UIView.animate(withDuration: kAnimationDuration - 1.0, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 15.0, options: [], animations: {
            self.animatedLogo.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { (completion) in
            
        })
        UIView.animate(withDuration: 0.75, delay: kAnimationDuration - 1.7, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [], animations: {
            self.animatedLogo.transform = CGAffineTransform(scaleX: 5.0, y: 5.0) // Return to original state
            self.animatedLogo.alpha = 0.0 // Make transparent
        }, completion: nil)
        
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(segueToRootVC), userInfo: nil, repeats: false) // Go to root VC after delay
    }
    
    @objc func segueToRootVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: Storyboard.rootViewController)
        let segueToMain: FadeSegue = FadeSegue(identifier: SegueIdentifiers.splashToMain, source: self, destination: destinationVC)
        segueToMain.perform()
    }
    
    open override var prefersStatusBarHidden : Bool {
        return true
    }
}
