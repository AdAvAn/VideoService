//
//  Collection.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import UIKit

extension Collection where Iterator.Element: UITextField {
    
    /**
     This method goes through an array of text fields, and assigns the action of the .NEXT "the next responder" to the second element of the array and DONE to the last element.
     And also adds actions to the specified buttons
     */
    func assignReturnKeyType() {
        
        var list = Array(self)
        
        guard let last = list.last else { return }
        
        for i in 0 ..< list.count - 1 {
            list[i].returnKeyType = .next
            list[i].addTarget(list[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
        
        last.returnKeyType = .done
        last.addTarget(last, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
    }
}
