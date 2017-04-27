//
//  Featured.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//


import Foundation
import UIKit


class FeaturedViewController: BaseViewController {
    
    @IBOutlet weak var someTableView: UITableView!
    
    override func viewDidLoad() {
        super.tableView = self.someTableView
        super.videosSections = .sectionFeatured
        super.viewDidLoad()
    }
    
    
}


