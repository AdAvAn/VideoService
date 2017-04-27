//
//  String.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/27/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import Foundation


extension String {
    
    /** Base 64 Encoded */
    var fromBase64: String {
        guard let data = Data(base64Encoded: self) else {
            return ""
        }
        return String(data: data, encoding: .utf8)!
    }
    
}
