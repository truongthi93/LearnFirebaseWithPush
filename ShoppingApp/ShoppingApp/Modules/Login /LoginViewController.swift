//
//  LoginViewController.swift
//  ShoppingApp
//
//  Created by ThiVo on 3/14/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import FirebasePerformance

class LoginViewController: BaseViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnLoginFB: FBSDKLoginButton!
    @IBOutlet weak var signInBtn: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        btnLoginFB.delegate = self

        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        
        let trace = Performance.startTrace(name: "test trace")
        trace?.incrementMetric("retry", by: 1)
        trace?.stop()

    }
    
    @IBAction func btnCreateNewUserByEmail(_ sender: Any) {
        guard let email = tfEmail.text, let password = tfPassword.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            print("Created User")
        }
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        guard let email = tfEmail.text, let password = tfPassword.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard user != nil else { return }
            
            let nav = UINavigationController()
            let homeViewController = HomeViewController()
            homeViewController.loginType = .email
            nav.viewControllers = [homeViewController]
            self?.present(nav, animated: true, completion: {
                print("move to main")
            })
        }
    }
    
    @IBAction func sifnInGG(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }

    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        guard signIn.currentUser != nil else {
            return
        }
        let nav = UINavigationController()
        let homeViewController = HomeViewController()
        homeViewController.loginType = .google
        nav.viewControllers = [homeViewController]
        self.present(nav, animated: true, completion: {
            print("move to main")
        })
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("sdfsd")
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("dsf")
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Log in OK")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Log out")
    }

    @IBAction func imageRecognizing(_ sender: Any) {
        let nav = UINavigationController()
        let homeViewController = RecognizingViewController()
        nav.viewControllers = [homeViewController]
        self.present(nav, animated: true, completion: {
            print("move to main")
        })
    }
}
