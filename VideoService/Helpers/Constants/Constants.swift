//
//  Constants.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import Foundation



import Foundation


struct Constants {
   
    static let apiURL: String = {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let url = dict!.object(forKey: "url") as! String

        return url.fromBase64
    }()
    
    /** The appearance of the activity indicator will begin after the specified time */
    static let startActivityIndicatorDelay: TimeInterval = TimeInterval(0.0)
    
    /** Maximum image loading time */
    static let imgLoadingRegestTimeOut: Double = 15.0
    
    /** videos loading Offset */
    static let videosOffset: Int = 10
    
    /** videos loading Offset */
    static let videoslimit: Int = 10
    
}
