//
//  LoginViewController.swift
//  ShoppingApp
//
//  Created by ThiVo on 3/14/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func textRecognizing(_ sender: Any) {
        let nav = UINavigationController()
        let homeViewController = RecognizingViewController()
        homeViewController.recognizeType = .text
        nav.viewControllers = [homeViewController]
        self.present(nav, animated: true, completion: {
            print("move to main")
        })
    }
    
    @IBAction func faceRecognizing(_ sender: Any) {
        let nav = UINavigationController()
        let homeViewController = RecognizingViewController()
        homeViewController.recognizeType = .face
        nav.viewControllers = [homeViewController]
        self.present(nav, animated: true, completion: {
            print("move to main")
        })
    }
}
