//
//  ApiManager.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import Alamofire

class ApiManager<SomeModel> {
    
    typealias RequestCallback = (SomeModel?) -> Void
    
    var request: SimpleRequests<SomeModel>
    
    init(for request: SimpleRequests<SomeModel>){
        self.request = request
    }
    
    
    public func simpleRequest(completion: @escaping RequestCallback) {
        
        
        //if there is no connection to the network not to run a network request
        if  !HaveConnectionToInternet.chek {
            Alert.alert(AllertMessagesTitle.error, message: AllertMessages.noInternetConnection)
            return
        }
        
        
        
        self.startActivity()
        
        
       // print(self.request.url, request.parameter) // debug
        
        Alamofire.request(request.url, method:request.method, parameters:request.parameter).responseJSON {response in
            
            // print(response.debugDescription) // debug
            
            defer { self.stopActivity() }
            
            if !self.errorHandlerFor(response){
                completion(nil)
                return
            }
            
            
            //get request model
            guard let result = self.request.completion?(response) else {
                Alert.alert(AllertMessagesTitle.error, message: AllertMessages.dataProcessingError)
                completion(nil)
                return
            }
            
            completion(result)
        }
        
    }
    
    
    
    private func startActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    private func stopActivity() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    private func errorHandlerFor(_ response: DataResponse<Any> ) -> Bool {
        
        //step 1: result.isFailure
        if response.result.isFailure {
            Alert.alert(AllertMessagesTitle.error, message: AllertMessages.unknownError)
            return false
        }
        
        //step 2: api 4xx error
        if let _ = ErrorCompletions.error4xx(response)  { return false  }
        
        //Yes!
        return true
    }
}
