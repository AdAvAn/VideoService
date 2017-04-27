//
//  VideosRequests.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation


enum VideosSections: String {
    case sectionNew = "/new"
    case sectionFeatured = "/featured"
    case sectionFollowing = "/following"
}


class VideosRequests: DefaultRequests {
    
    
    init(category: Categories, offset: Int, limit:Int, accessToken:String? = nil){
        super.init(category, offset, limit, accessToken)
    }
    
    
    
    
    /** Creates a request show videos list  */
    func videos(from section: VideosSections) -> RequestsBuilder<Videos> {
        
        let builder  = RequestsBuilder<Videos> { [unowned self] builder in
            builder.url =  self.url(width: section.rawValue)
            builder.completion = VideosCompletions.videosCompletions
            builder.method = .get
            builder.parameter = self.parameters
        }
        
        return builder
    }
    
    
}

