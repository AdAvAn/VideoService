//
//  AuthRequests.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import Foundation

enum AuthSections: String {
    case sectionCheck = "/check"
    case sectionCreate = "/create"
    case sectionDelete = "/delete"
}


class AuthRequests: DefaultRequests {
    
    
    init(category: Categories, offset: Int? = nil, limit:Int? = nil, accessToken:String? = nil){
        super.init(category, offset, limit, accessToken)
    }
    
    /** Creates a request show videos list  */
    func authCreate(username:String, password:String) -> RequestsBuilder<Auth> {
        
        let builder = RequestsBuilder<Auth> { [unowned self] builder in
            builder.url =  self.url(width: AuthSections.sectionCreate.rawValue)
            builder.completion = AuthCompletions.auth
            builder.method = .post
            builder.parameter = ["username": username, "password": password]
        }
        
        return builder
    }
    
    
    /** Creates a request check user auth  */
    var  authChek:RequestsBuilder<Auth> {
        
        
        let builder  = RequestsBuilder<Auth> { [unowned self] builder in
            builder.url =  self.url(width: AuthSections.sectionCheck.rawValue)
            builder.completion = AuthCompletions.auth
            builder.method = .post
            builder.parameter = ["token" : UserContext.instance.token ?? ""]
        }
        
        return builder
    }
    
    /** Creates a request user auth delete  */
    var  authDelete:RequestsBuilder<Auth> {
        let authDelete = self.authChek
        authDelete.url = self.url(width: AuthSections.sectionDelete.rawValue)
        return authDelete
    }
    
    
}
