//
//  DefaultCompletions.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import Gloss

struct DefaultCompletions {
    
    /**
     This unit uses when it is not required to perform the action on the request result
     */
    static var terminator: CompletionBlock<Any> = { _ in
        return ()
    }
    
}

struct ErrorCompletions {
    
    /** Handle 4XX errors from the API  */
    static var error4xx: CompletionBlock<Error4xx> = { response in
        
        
        //MARK:Safety
        guard
            let json = response.value as? JSON,
            let error4xx = ErrorCreate.instance.createError(from: json)// createVideos(from: json)
            else {
                return nil
        }
        
        
        Alert.alert(AllertMessagesTitle.error, message: error4xx.error)
        
        return error4xx
    }
    
}

