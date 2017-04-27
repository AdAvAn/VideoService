//
//  VideosCompletions.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import Alamofire
import Gloss

struct VideosCompletions {
    
    
    static var videosCompletions: CompletionBlock<Videos> = {  response in
        
        //MARK:Safety
        guard
            let json = response.value as? JSON,
            let videos = VideosCreate.instance.createVideos(from: json)
            
            else {
                print("Error getting object JSON")
                return nil
        }
        
        
        
        //MARK:Caches
        //Caches data if necessary
        
        
        
        
        return videos
    }
    
}
