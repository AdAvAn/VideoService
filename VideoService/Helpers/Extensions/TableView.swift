//
//  TableView.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import UIKit



extension UITableView {
    
    /**
     Scrolls the table to the Calculated by the formula Row.
     
     - parameter toatal: Of all elements in the table.
     - parameter offset: Load new element offset.
     - parameter section: Section number
     */
    public func scrollToRow(for toatalRow: Int, сurrentUpdate: Int,  section:Int = 0){
        
        if toatalRow > сurrentUpdate {
            
            let moveToIndexPath = IndexPath(item: (toatalRow-(сurrentUpdate+1)), section: section)
            self.scrollToRow(at: moveToIndexPath, at: .none, animated: true)
        }
        
    }
    
    
}
