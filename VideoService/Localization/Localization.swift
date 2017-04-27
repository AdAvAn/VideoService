//
//  Localization.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import Foundation

struct InformationMessages {
    static let  loading =  NSLocalizedString("Loading...", comment: "loading")
    static let  login =  NSLocalizedString("Login...", comment: "Login")
}



struct AllertMessagesTitle {
    static let error  =  NSLocalizedString("Error", comment: "error")
}



struct AllertMessages {
    static let unknownError =  NSLocalizedString("Unknown error", comment: "Any error without description")
    static let dataProcessingError =  NSLocalizedString("Data processing error, plaese try again later", comment: "Error while creating model")
    static let noInternetConnection =   NSLocalizedString("No connection to the Internet, plaese try again later", comment: "No connection to the Internet")
}
