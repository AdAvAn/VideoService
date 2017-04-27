//
//  Function.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import UIKit

/** Performs specified actions with a delay */
public func delay( bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main,  closure: @escaping () -> Void) {
    
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}



/** This enumeration can provide the required flow for the task of key */
public enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}


/** Will show the next controller specified in the incoming parameters */
@discardableResult
public func showMе<T: UIViewController>(controller: T.Type, controllerId: String, storyboardId: String, above viewController:UIViewController) -> T {
    
    let storyboard = UIStoryboard(name: storyboardId, bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: controllerId) as! T
    
    viewController.addChildViewController(controller)
    viewController.view.addSubview(controller.view)
    controller.didMove(toParentViewController: viewController)
    
    
    return controller
}

