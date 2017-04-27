//
//  VideosModel.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import Gloss


/** Lists new videos */
protocol Videos {
    
    /** Object videos Array<Video> */
    var videos: Array<Video> {get}
}




/** Creator of new video lists  */
struct VideosCreate {
    
    static let instance: VideosCreate = VideosCreate()
    
    /** Will create a list of videos with the minimum necessary data */
    func createVideos(from data:JSON) -> Videos? {
        return DefaultVideos(json: data)
    }
}



/** Will create a standard video list object */
struct DefaultVideos: Decodable, Videos {
    
    //var page: Page
    var videos: Array<Video>
    
    init?(json: JSON) {
        
        guard
            //let page: Page = "page" <~~ json,
            let videos: Array<Video> = "videos" <~~ json
            else {
                print("ERROR: Default Video has not init")
                return nil
        }
        
        
        //This check is necessary in order to skip those videos that do not have a link to the video clip
        let videosWithRealLinks = videos.flatMap { (video)->Video? in  (video.complete_url != nil) ? video : nil }.flatMap{$0}
        
        // self.page = page
        self.videos = videosWithRealLinks
    }
}



/** Object for the standard video clip */
struct Video: Decodable {
    
    /** The full URL to the video thumbnail */
    var thumbnail_url: URL
    
    /** The full URL to the completed, encoded video object */
    var complete_url: URL?
    
    /** The video title */
    var title: String
    
    /** The number of likes on all of the user's videos */
    var likes_count: Int
    
    
    init?(json: JSON) {
        
        //MARK: Required fields
        guard
            let thumbnail_url: URL = "thumbnail_url" <~~ json
            
            else {
                print("ERROR:  Video has not init, ")
                return nil
        }
        
        self.complete_url = "complete_url" <~~ json
        
        let likes_count: Int? = "likes_count" <~~ json
        let title: String? = "title" <~~ json

        
        
        
        
        
        self.thumbnail_url = thumbnail_url
        self.title = title ?? ""
        self.likes_count = likes_count ?? 0
        
        
    }
}



/** Additional information on the contents of the list information on the content */
struct Page: Decodable {
    
    /** Total items matching query. */
    let total: Int
    
    /** The effective result limit */
    let offset: Int
    
    /** The effective result offset */
    let limit: Int
    
    init?(json: JSON) {
        
        guard
            let total: Int = "total" <~~ json,
            let offset: Int = "offset" <~~ json,
            let limit: Int = "limit" <~~ json
            else {
                print("ERROR: Page has not init")
                return nil
        }
        
        self.total = total
        self.offset = offset
        self.limit = limit
    }
}
