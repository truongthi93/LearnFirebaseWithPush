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

enum RecognizeType {
    case face
    case text
}

class RecognizingViewController: BaseViewController {
    @IBOutlet weak var imgShot: UIImageView!
    @IBOutlet weak var lblResult: UILabel!
    var recognizeType : RecognizeType = .text
    lazy var vision = Vision.vision()

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
        vc.recognizeType = self.recognizeType
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RecognizingViewController: TakePhotoDelegate{
    func pass(_ photo: UIImage) {
        if self.recognizeType == .text{
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
        } else {
            lblResult.text = ""
            self.imgShot.image = photo

            // face
            // High-accuracy landmark detection and face classification
            let options = VisionFaceDetectorOptions()
            options.performanceMode = .accurate
            options.landmarkMode = .all
            options.classificationMode = .all
            
            // Real-time contour detection of multiple faces
            //        let options = VisionFaceDetectorOptions()
            //        options.contourMode = .all
            
            let faceDetector = self.vision.faceDetector(options: options)
            
            //let image = VisionImage(image: photo)
            let image = VisionImage(image: UIImage(named: "3people")!)

            faceDetector.process(image) { features, error in
                guard error == nil, let features = features, !features.isEmpty else {
                    // ...
                    return
                }
                
                // Faces detected
                // ...
                for face in features {
                    let frame = face.frame
                    if face.hasHeadEulerAngleY {
                        let rotY = face.headEulerAngleY  // Head is rotated to the right rotY degrees
                    }
                    if face.hasHeadEulerAngleZ {
                        let rotZ = face.headEulerAngleZ  // Head is rotated upward rotZ degrees
                    }
                    
                    // If landmark detection was enabled (mouth, ears, eyes, cheeks, and
                    // nose available):
                    if let leftEye = face.landmark(ofType: .leftEye) {
                        let leftEyePosition = leftEye.position
                    }
                    
                    // If contour detection was enabled:
                    if let leftEyeContour = face.contour(ofType: .leftEye) {
                        let leftEyePoints = leftEyeContour.points
                    }
                    if let upperLipBottomContour = face.contour(ofType: .upperLipBottom) {
                        let upperLipBottomPoints = upperLipBottomContour.points
                    }
                    
                    // If classification was enabled:
                    if face.hasSmilingProbability {
                        let smileProb = face.smilingProbability
                    }
                    if face.hasRightEyeOpenProbability {
                        let rightEyeOpenProb = face.rightEyeOpenProbability
                    }
                    
                    // If face tracking was enabled:
                    if face.hasTrackingID {
                        let trackingId = face.trackingID
                    }
                }
            }

        }
    }
    
    func fail() {
        if self.recognizeType == .text{
            lblResult.text = "fail"
        } else {
            // face
            lblResult.text = "fail"
        }
    }
}
