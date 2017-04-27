//
//  FeedLogon.swift
//  VideoService
//
//  Created by Vlasiuk Dmitriy on 4/26/17.
//  Copyright © 2017 VideoService.me. All rights reserved.
//

import Foundation
import UIKit

class FeedLogon: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    //API requests settings
    lazy private var authRequests: AuthRequests = AuthRequests(category: .auth)
    lazy var spinner: Spinner = Spinner(title: InformationMessages.login)
    
    weak var vserActionDelegate : UserActionDelegate?
    lazy var textFields: Array<UITextField> = { return [self.usernameTextField, self.passwordTextField] }()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        self.loginButton.layer.cornerRadius = 4
        
        self.spinner.setup()
        self.view.addSubview( self.spinner)
        
        textFields.first?.fierstResponse()
        textFields.assignReturnKeyType()
        
    }
    
    
    /**  User authorization process */
    @IBAction func loginAction(_ sender: Any) {
        self.spinner.show()
        
        self.authRequests.authCreate(username: usernameTextField.text! , password: passwordTextField.text!).send.simpleRequest{  [unowned self]  response in
            defer { self.spinner.hide() }
            guard let _ = response else { return }
            
            if let vserAction = self.vserActionDelegate {
                vserAction.action(width: self)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
}
