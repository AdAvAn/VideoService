//
//  UITextField.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    /** Determines whether the field can become the first response, and designate it as the first one in success. */
    func fierstResponse(){
        if self.canBecomeFirstResponder{
            self.becomeFirstResponder()
        }
    }
    
}

