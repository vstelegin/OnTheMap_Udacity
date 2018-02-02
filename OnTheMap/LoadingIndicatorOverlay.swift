//
//  LoadingOverlay.swift
//  OnTheMap
//
//  Created by Chase on 01/02/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation
import UIKit

class LoadingIndicatorOverlay {
    var indicator = UIActivityIndicatorView()
    var overlayView = UIView()
    
    static let shared = LoadingIndicatorOverlay()
    
    public func showIndicator(_ view: UIView) {
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        indicator.center = overlayView.center
        overlayView.addSubview(indicator)
        indicator.startAnimating()
        view.addSubview(overlayView)
    }
    
    public func hideIndicator() {
        indicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
