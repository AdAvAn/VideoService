//
//  Requests.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import Alamofire
import Gloss
import SystemConfiguration

typealias CompletionBlock<SomeModel> = (_ requests: DataResponse<Any>) -> SomeModel?




/** The protocol that describes the composition of requests */
protocol Requests  {
    
    associatedtype Model
    
    var url: String {get}
    var headers: HTTPHeaders {get}
    var completion: CompletionBlock<Model>? {get}
    var method: HTTPMethod {get}
    var parameter: URLParameters {get}
    
}


/** Build a request object*/
class RequestsBuilder<SomeModel>: Requests {
    
    typealias Model = SomeModel
    typealias RequestsClosure = (RequestsBuilder) -> ()
    
    var url:  String = ""
    var headers: HTTPHeaders = Dictionary<String, String>()
    var method: HTTPMethod = .get
    var parameter: URLParameters = ["" : ""]
    var completion: CompletionBlock<SomeModel>?  = nil
    
    init(requestsClosure: RequestsClosure) {
        requestsClosure(self)
    }
    
}




/** Creates a simple query */
struct SimpleRequests<SomeModel>: Requests  {
    
    typealias Model = SomeModel
    
    var url:  String
    var headers: HTTPHeaders
    var completion: CompletionBlock<Model>?
    var method: HTTPMethod
    var parameter: URLParameters
    
    init(builder: RequestsBuilder<SomeModel>) {
        self.url = builder.url
        self.headers = builder.headers
        self.completion = builder.completion //.completion
        self.method = builder.method
        self.parameter = builder.parameter
    }
}




extension RequestsBuilder {
    
    /** Will create a request object */
    private var buildSimpleRequest: SimpleRequests<SomeModel> {
        return SimpleRequests<SomeModel>(builder: self)
    }
    
    /** This method sends data to the server. */
    var send: ApiManager<SomeModel> {
        return ApiManager<SomeModel>(for: buildSimpleRequest)
    }
    
}



/** This structure verifies connectivity with Internet */
struct HaveConnectionToInternet {
    
    public static var chek: Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
}

