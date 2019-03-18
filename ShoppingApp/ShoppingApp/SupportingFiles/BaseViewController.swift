//
//  BaseViewController.swift
//  ShoppingApp
//
//  Created by ThiVo on 2/28/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//
import UIKit

class BaseViewController: UIViewController {
    var darkMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        setUpNavigationColor()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return darkMode ? .default : .lightContent
    }
    
    func setUpNavigationColor() {
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.navigationTextColor]
    }
    
}
