//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by ThiVo on 2/28/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase //again, tried with/without this line
import FirebaseAuth
import GoogleSignIn

enum LoginType {
    case email
    case google
}

class HomeViewController: BaseViewController {
    public var homeView: HomeView! {
        guard isViewLoaded else { return nil }
        return view as? HomeView
    }
    var loginType : LoginType = .email
    var listItem = [TrendKeyword]()
    var handle: AuthStateDidChangeListenerHandle?
    override func viewDidLoad() {
        super.viewDidLoad()

        darkMode = true
        setNeedsStatusBarAppearanceUpdate()
        self.setUpNavigationBar()
        self.setUpCollectionView()
        //self.getTrendKeywordListUsingWebService()
        self.getTrendKeywordListUsingFireBase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch self.loginType {
        case .email:
            self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                if let user = user {
                    // The user's ID, unique to the Firebase project.
                    // Do NOT use this value to authenticate with your backend server,
                    // if you have one. Use getTokenWithCompletion:completion: instead.
                    let uid = user.uid
                    let email = user.email
                    let photoURL = user.photoURL
                    print("User Info: \(uid),  \(email ?? ""), \(String(describing: photoURL))")
                    self.homeView.lblUser.text = email
                }
            }
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUpNavigationBar(){
        self.title = Constants.AppCommon.homeTitle
        
        self.navigationController?.navigationBar.tintColor = UIColor.navigationTextColor
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.add,
            target: self,
            action: #selector(addNewProduct)
        )

        let btnInfo = UIButton(type: .custom)
        btnInfo.setTitle(Constants.AppCommon.info, for: .normal)
        btnInfo.setTitleColor(UIColor.navigationTextColor, for: .normal)
        btnInfo.addTarget(self, action: #selector(HomeViewController.btnInfoClick(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnInfo)
    }
    
    @objc func addNewProduct(sender: UIButton!) {
        let vc = NewProductViewController(nibName: "NewProductViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnInfoClick(_ sender: AnyObject) {
        let btnOK = UIAlertAction(title: NSLocalizedString(Constants.AppCommon.OK, comment: ""), style: .cancel, handler: nil)
        btnOK.setValue(UIColor.black, forKey: Constants.AppCommon.titleTextColor)
        Utilities.showAlert(title: Constants.AppCommon.info, message: Constants.Info.infoData, buttons: [btnOK], context: self)
    }
    
    func setUpCollectionView() {
        homeView.HotKeyCollectionView.delegate = self
        homeView.HotKeyCollectionView.dataSource = self
        homeView.HotKeyCollectionView.register(UINib(nibName: Constants.AppCommon.homeCellKey, bundle: nil), forCellWithReuseIdentifier:Constants.AppCommon.homeCellKey)

    }
    
    func getTrendKeywordListUsingWebService() {
        DataManager.shareInstance.getTrendKeywordList { (list, error) -> (Void) in
            if let keywordList = list?.keywords, keywordList.count > 0{
                self.listItem = keywordList
                self.homeView.HotKeyCollectionView.reloadData()
            } else {
                // Show error
                //print("error")
            }
        }
    }
    
    func getTrendKeywordListUsingFireBase() {
        self.databaseRef.child("TrendKeyword").queryOrdered(byChild: "keyword").observe(.value) { snapshot in
            var keywords = [TrendKeyword]()
            for keywordSnapshot in snapshot.children {
                let keyword = TrendKeyword(snapshot: keywordSnapshot as! DataSnapshot)
                keywords.append(keyword)
            }
            self.listItem = keywords
            self.homeView.HotKeyCollectionView.reloadData()
        }

    }

    @IBAction func btnLogOutClick(_ sender: Any) {
        switch self.loginType {
        case .email:
            guard let handle = self.handle else {
                return
            }
            self.dismiss(animated: true) {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        default:
            self.dismiss(animated: true) {
                GIDSignIn.sharedInstance().signOut()
            }
            break
        }
    }
    
    @IBAction func btnFireStoreClick(_ sender: Any) {
        let vc = FireStoreHomeViewController(nibName: "FireStoreHomeViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
