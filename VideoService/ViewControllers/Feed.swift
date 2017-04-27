//
//  Feed.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import UIKit

class FeedViewController: BaseViewController, UserActionDelegate {
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var someTableView: UITableView!
    
    let authRequests: AuthRequests = AuthRequests(category: .auth)
    
    
    override func viewDidLoad() {
        super.tableView = self.someTableView
        super.videosSections = .sectionFollowing
        
        if !UserContext.instance.isAuthorized {
            self.showMyFeedLogon()
            return
        }
        
        super.viewDidLoad()
        
        self.logOutButton.layer.borderWidth = 1
        self.logOutButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    
    
    /** User Action Delegate method  */
    func action(width:UIViewController) {
        
        width.removeFromParentViewController()
        width.view.removeFromSuperview()
        
        self.videos.removeAll()
        self.tableView.reloadData()
        super.viewDidLoad()
        
    }
    
    
    
    /**  The process of logging out of the system */
    @IBAction func logOutAction(_ sender: Any) {
        self.spinner.show()
        
        authRequests.authDelete.send.simpleRequest{  [unowned self]  response in
            defer { self.spinner.hide() }
            
            guard let _ = response else { return }
            self.showMyFeedLogon()
        }
    }
    
    
    /** Will show the authorization controller */
    public func showMyFeedLogon(){
        let vc = showMе(controller: FeedLogon.self, controllerId: "FeedLogon", storyboardId: "Main", above: self)
        vc.vserActionDelegate = self
    }
    
}
