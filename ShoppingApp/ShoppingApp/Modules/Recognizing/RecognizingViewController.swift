//
//  RecognizingViewController.swift
//  ShoppingApp
//
//  Created by ThiVo on 3/18/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMLVision
import AVFoundation

class RecognizingViewController: BaseViewController {
    @IBOutlet weak var imgShot: UIImageView!
    @IBOutlet weak var lblResult: UILabel!
    let textRecognizer = ""
    let vision = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        darkMode = true
        setNeedsStatusBarAppearanceUpdate()
        self.setUpNavigationBar()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUpNavigationBar(){
        self.title = "Recognizing Screen"
        self.navigationController?.navigationBar.tintColor = UIColor.navigationTextColor
        
        let btnInfo = UIButton(type: .custom)
        btnInfo.setTitle(Constants.AppCommon.info, for: .normal)
        btnInfo.setTitleColor(UIColor.navigationTextColor, for: .normal)
        btnInfo.addTarget(self, action: #selector(RecognizingViewController.btnInfoClick(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnInfo)

    }
    
    @objc func btnInfoClick(_ sender: AnyObject) {
        let vc = TakeCameraViewController(nibName: "TakeCameraViewController", bundle: nil)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RecognizingViewController: TakePhotoDelegate{
    func pass(_ photo: UIImage) {
        lblResult.text = ""
        self.imgShot.image = photo
        
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        let image = VisionImage(image: photo)
        
        textRecognizer.process(image) { result, error in
            guard error == nil, let result = result else {
                // ...
                return
            }
            print("result")
            print(result.text)
            self.lblResult.text = result.text
        }
    }
    
    func fail() {
        lblResult.text = "fail"
    }
}
