//
//  UserContext.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import SwiftKeychainWrapper

protocol State {
    func isAuthorized(context: UserContext) -> Bool
    func token(context: UserContext) -> String?
}


/** Knows everything about user status */
final class UserContext {
    
    static let instance: UserContext = UserContext()
    
    private var state: State = DeterminantState.state
    
    
    var isAuthorized: Bool {
        get { return state.isAuthorized(context: self) }
    }
    
    var token: String? {
        get { return state.token(context: self) }
    }
    
    func changeStateToAuthorized(token: String) {
        state = AuthorizedState(token: token)
        print("USER IS Authorized token: \(token)") //debud
    }
    
    func changeStateToUnauthorized() {
        state = UnauthorizedState()
        print("USER IS Unauthorized") //debud
    }
    
}


/** Action actions for an unauthorized user */
class UnauthorizedState: State {
    
    init(){
        KeychainWrapper.standard.removeObject(forKey: "token") //remove token
    }
    
    func isAuthorized(context: UserContext) -> Bool { return false }
    func token(context: UserContext) -> String? { return nil  }
}


/** Actions of an authorized user */
class AuthorizedState: State {
    
    let token: String
    
    init(token: String) { self.token = token }
    
    func isAuthorized(context: UserContext) -> Bool {  return true }
    
    func token(context: UserContext) -> String? { return token }
}


/** Determines the state of the object */
fileprivate struct DeterminantState {
    /** Returns the current state of the user based on the availability  based on data from CoreData */
    static var state: State  = {
        let token: String? = KeychainWrapper.standard.string(forKey: "token")
        return (token == nil) ? UnauthorizedState() : AuthorizedState(token: token!)
        
    }()
}
