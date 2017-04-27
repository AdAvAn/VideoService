//
//  ActivityIndicator.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import UIKit


public typealias IndicatorView = UIView




/** Activity Indicator Protocol */
public protocol Indicator {
    func start()
    func stop()
    
    var viewCenter: CGPoint { get set }
    var view: IndicatorView { get }
}


extension Indicator {
    public var viewCenter: CGPoint {
        get {
            return view.center
        }
        set {
            view.center = newValue
        }
    }
}



/** Displays a  Activity Indicator  */
struct ActivityIndicator: Indicator {
    
    //MARK: SETUP
    
    var globalView: UIView
    
    init(view:UIView) {
        self.globalView = view
        
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
        
        self.viewCenter = CGPoint(x: view.frame.width/2.0, y: view.frame.height/2.0 )
    }
    
    
    
    // MARK: PUBLIC
    
    /** To this View will be added an indicator */
    var view: IndicatorView {
        return activityIndicatorView
    }
    
    /** Starts and adds an indicator to the current view */
    func start() {
        globalView.addSubview(view)
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
    }
    
    /** Stop and remove the indicator */
    func stop() {
        activityIndicatorView.removeFromSuperview()
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
        view.removeFromSuperview()
    }
    
    
    
    // MARK: PRIVATE
    private var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
}
