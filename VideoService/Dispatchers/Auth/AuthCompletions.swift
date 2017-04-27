//
//  AuthCompletions.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import Foundation
import Gloss

struct AuthCompletions {
    
    
    static var auth: CompletionBlock<Auth> = {  response in
        
        //MARK:Safety
        guard
            let json = response.value as? JSON,
            let authData = AuthCreate.instance.createAuth(from: json)
            else {
                print("Error getting object JSON")
                return nil
        }
        
        //MARK:Caches
        //Caches data if necessary
        
        
        //MARK: USER
        //Change user status
        if authData.status &&  authData.auth != nil {
            if (authData.auth!.saveUserToken)  { authData.auth!.autorized(status: true) }
        }else{
            UserContext.instance.changeStateToUnauthorized()
        }
        
        return authData
    }
    
}
