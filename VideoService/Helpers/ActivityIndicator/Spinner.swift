//
//  Spinner.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import UIKit



class Spinner: UIVisualEffectView {
    
    //MARLK :SETUP
    
    private var text: String? {
        didSet {
            label.text = text
        }
    }
    private let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    private let label: UILabel = UILabel()
    private let blurEffect = UIBlurEffect(style: .dark)
    private let vibrancyView: UIVisualEffectView
    
    
    init(title: String) {
        self.text = title
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    
    //MARK: PUBLIC
    
    public func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        self.hide()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: width - activityIndicatorSize - 15,
                                 height: height)
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    
    /** Will show the indicator */
    public func show() {
        self.activityIndictor.startAnimating()
        self.isHidden = false
    }
    
    /** Will hide the indicator */
    public func hide() {
        self.activityIndictor.stopAnimating()
        self.isHidden = true
    }
    
}
