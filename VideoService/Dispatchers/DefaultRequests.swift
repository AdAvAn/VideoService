//
//  DefaultRequests.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation



typealias URLParameters = Dictionary<String,Any>


/** List of available categories */
enum Categories: String {
    case videos = "/videos"//"/videos"
    case auth = "/auth"
}



class DefaultRequests {
    
    
    init(_ category: Categories, _ offset: Int? = nil, _ limit:Int? = nil, _ accessToken:String? = nil) {
        self.category = category
        self.offset = offset
        self.limit = limit
        // self.accessToken = accessToken
    }
    
    
    //MARK: SETTINGS
    
    
    
    /** The user authentication token. May use token parameter instead */
    private var accessToken: String? {
        get{
            return  UserContext.instance.token
        }
    }
    public var offset: Int? //Result offset
    private var limit: Int? // Result limit (1-100)
    
    
    //url settings
    private var baseURL: String = Constants.apiURL //Block address
    private var category: Categories //Unit url
    
    
    
    //MARK: PUBLIC
    
    
    
    /** Advanced query parameters */
    public var parameters: URLParameters {
        get{
            var param: URLParameters  = [:]
            param["offset"] = offset ?? ""
            param["limit"] = limit ?? ""
            param["token"] = accessToken ?? ""
            
            return param
        }
    }
    
    
    
    /** Contains the full address of the object */
    public func url(width unitUrl: String) ->  String {
        return   self.prepareUrl + unitUrl
    }
    
    
    //MARK: PRIVATE
    
    
    /** Returns the string with the service's gross address and the address of the first-level block */
    private var prepareUrl: String {
        get {
            return   self.baseURL + self.category.rawValue
        }
    }
}

