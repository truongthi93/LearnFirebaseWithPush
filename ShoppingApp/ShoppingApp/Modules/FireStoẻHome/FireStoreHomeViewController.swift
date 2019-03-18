//
//  FireStoreHomeViewController.swift
//  ShoppingApp
//
//  Created by ThiVo on 3/15/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
import Crashlytics
import Fabric

class FireStoreHomeViewController: BaseViewController {
    var listItem = [TrendKeyword]()
    var handle: AuthStateDidChangeListenerHandle?
    @IBOutlet weak var HotKeyCollectionView: UICollectionView!
    var ref: DocumentReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "ahihi",
            AnalyticsParameterItemName: "xot",
            AnalyticsParameterContentType: "cont"
            ])

        Analytics.logEvent("thiuit", parameters: [
            "thivo": "mmmm",
            "vothi": "mmmmdfgdf"
            ])

        
        darkMode = true
        setNeedsStatusBarAppearanceUpdate()
        self.setUpNavigationBar()
        self.setUpCollectionView()
        addNewInFireStore()
        add2NewInFireStore()
        //self.getTrendKeywordListUsingWebService()
        self.getTrendKeywordListUsingFireStore()
        
        Fabric.sharedSDK().debug = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUpNavigationBar(){
        self.title = Constants.AppCommon.homeTitle
        
        self.navigationController?.navigationBar.tintColor = UIColor.navigationTextColor
    }
    
    func setUpCollectionView() {
        self.HotKeyCollectionView.delegate = self
        self.HotKeyCollectionView.dataSource = self
        self.HotKeyCollectionView.register(UINib(nibName: Constants.AppCommon.homeCellKey, bundle: nil), forCellWithReuseIdentifier:Constants.AppCommon.homeCellKey)
    }
    
    func getTrendKeywordListUsingFireStore() {
        //Get ALL
        self.fireStore.collection("TrendKeyword").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var keywords = [TrendKeyword]()
                
                for document in snapshot!.documents {
                    let docId = document.documentID
                    let keyword = document.get("keyword") as! String
                    let icon = document.get("icon") as! String
                    
                    let newKeyword = TrendKeyword(id: docId, keyword: keyword, icon: icon)
                    keywords.append(newKeyword)
                }
                self.listItem = keywords
                self.HotKeyCollectionView.reloadData()
                
            }
        }
        
        // Simple query
        self.fireStore.collection("TrendKeyword").whereField("keyword", arrayContains: "thi")
            .getDocuments { (snapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var keywords = [TrendKeyword]()
                    
                    for document in snapshot!.documents {
                        let docId = document.documentID
                        let keyword = document.get("keyword") as! String
                        let icon = document.get("icon") as! String
                        
                        let newKeyword = TrendKeyword(id: docId, keyword: keyword, icon: icon)
                        keywords.append(newKeyword)
                    }
                    self.listItem = keywords
                    self.HotKeyCollectionView.reloadData()
                    
                }
        }
    }
    
    func addNewInFireStore(){
        // Add a new document with a generated ID
        self.ref = self.fireStore.collection("TrendKeyword").addDocument(data: [
            "icon": "Ada",
            "keyword": "Lovelace"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    func add2NewInFireStore(){
        // Add a second document with a generated ID.
        self.ref = self.fireStore.collection("TrendKeyword").addDocument(data: [
            "icon": "Alan",
            "keyword": "Mathison"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.ref!.documentID)")
            }
        }
    }
    
    // Crash
    @IBAction func OOIClick(_ sender: Any) {
        let a = [0,1,2]
        let b = a[4]
        print(b)
    }
    
    @IBAction func div0Click(_ sender: Any) {
        assert(false)
        Crashlytics.sharedInstance().crash()
//        let a = Int("2")
//        let b = Int("2a")
//        print(b)
    }
    
    @IBAction func printNil(_ sender: Any) {
        let a : String? = nil
        print(a!)

    }
}

extension FireStoreHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.HotKeyCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.AppCommon.homeCellKey, for: indexPath) as? TrendKeywordCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of NewsTableViewCell")
        }
        
        let hotKey = self.listItem[indexPath.row]
        cell.setUpCell(data: hotKey, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hotKey = self.listItem[indexPath.row]
        return Utilities.calculateWidthForHomeView(keyword: hotKey.keyword ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = self.listItem[indexPath.row].id else { return }
        self.fireStore.collection("TrendKeyword").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.getTrendKeywordListUsingFireStore()
            }
        }
    }
}
