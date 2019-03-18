//
//  BaseViewController.swift
//  ShoppingApp
//
//  Created by ThiVo on 2/28/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//
import UIKit
import FirebaseDatabase //tried not having this line, still the same
import FirebaseStorage //tried not having this line, still the same
import FirebaseFirestore

class BaseViewController: UIViewController {
    var darkMode = false
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    var fireStore: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        setUpNavigationColor()
        configureDatabase()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureDatabase() {
        //Gets a FIRDatabaseReference for the root of your Firebase Database.
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        fireStore = Firestore.firestore()

    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return darkMode ? .default : .lightContent
    }
    
    func setUpNavigationColor() {
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBarColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.navigationTextColor]
    }
    
}
