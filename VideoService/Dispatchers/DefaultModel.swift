//
//  DefaultModel.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import Gloss



struct Error4xx: Decodable {
    
    var status: Bool
    var error: String
    var code: String
    
    //MARK: Required fields
    init?(json: JSON) {
        guard
            let status: Bool = "status" <~~ json,
            let error: String = "error" <~~ json,
            let code: String = "code" <~~ json
            else {
                return nil
        }
        
        self.status = status
        self.error = error
        self.code = code
        
    }
}



/** Creator of new video lists  */
struct ErrorCreate {
    
    static let instance: ErrorCreate = ErrorCreate()
    
    /** Will create a list of videos with the minimum necessary data */
    func createError(from data:JSON) -> Error4xx? {
        return Error4xx(json: data)
    }
}
