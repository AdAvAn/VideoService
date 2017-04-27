//
//  AuthModel.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import Gloss
import SwiftKeychainWrapper


/** Lists new videos */
protocol Auth {
    var status: Bool {get}
    var auth: AuthData? {get}
}


/** Creator of new video lists  */
struct AuthCreate {
    
    static let instance: AuthCreate = AuthCreate()
    
    /** Will create a auth objec */
    func createAuth(from data:JSON) -> Auth? {
        return DefaultAuth(json: data)
    }
}



/** Will create a standard video list object */
struct DefaultAuth: Decodable, Auth {
    
    let status: Bool
    let auth: AuthData?
    
    init?(json: JSON) {
        
        guard
            let status: Bool = "status" <~~ json
            else {
                print("ERROR: Default Auth has not init")
                return nil
        }
        
        self.status = status
        self.auth = "auth" <~~ json
    }
}


/** Will create a standard Auth  */
struct AuthData: Decodable {
    
    
    /** The user authentication token */
    let token: String
    
    /** The date at which the token expires */
    let expires: String
    
    /** The user ID of the authentication token */
    let user_id: String
    
    
    init?(json: JSON) {
        
        guard
            let token: String = "token" <~~ json,
            let expires: String = "expires" <~~ json,
            let user_id: String = "user_id" <~~ json
            
            else {
                print("ERROR: Auth Data has not init")
                return nil
        }
        
        //save token
        
        
        self.token = token
        self.expires = expires
        self.user_id = user_id
        
    }
}


extension AuthData {
    
    var saveUserToken: Bool{
        return KeychainWrapper.standard.set(token, forKey: "token")
    }
    
    func autorized(status: Bool) {
        (status) ? UserContext.instance.changeStateToAuthorized(token: token) :  UserContext.instance.changeStateToUnauthorized()
    }
}

