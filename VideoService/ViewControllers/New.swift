//
//  New.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import Foundation
import UIKit


class NewViewController: BaseViewController {
    
    @IBOutlet weak var someTableView: UITableView!
    
    override func viewDidLoad() {
        self.spinner =  Spinner(title: InformationMessages.loading)
        super.tableView = self.someTableView
        super.videosSections = .sectionNew
        
        self.view.addSubview( self.spinner)
        
        super.viewDidLoad()
    }
    
    
}
