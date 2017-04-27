//
//  ImageLoader.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import Foundation
import UIKit




class ImageLoader: NSObject  {
    
    
    //MARK: SETTINS
    
    typealias completion = (UIImage?)->Void
    static let instance = ImageLoader()
    private var downloadQueue = Dictionary<URL, completion>()
    
    
    private override init() {
        super.init()
    }
    
    
    //MARK: PUBLIC
    
    
    /**
     This public method that produces an image, depending on conditions
     This method is available to access the data
     */
    public func getImage(from url:URL,  completion: @escaping completion) {
        loadImgeFromURL(url, completion)
    }
    
    
    //MARK: PRIVATE
    
    /** This method creates a task to download images from the API */
    private func loadImgeFromURL(_ url: URL,  _ completion: @escaping completion){
        self.startActivity()
        let data = try? Data(contentsOf: url, options: .alwaysMapped) //Data(contentsOf: url)
        self.img(data:data, completion)
    }
    
    
    /** This method tries to create Umag from raw data, and returns an image in the main stream */
    private func img(data: Data?, _ completion:  @escaping completion) {
        
        guard
            let data = data,
            let image = UIImage(data: data) else {
                completion(nil)
                return
        }
        
        self.stopActivity()
        completion(image)
    }
    
    
    private func startActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    private func stopActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
}
