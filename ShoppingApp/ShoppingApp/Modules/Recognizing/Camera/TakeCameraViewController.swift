//
//  TakeCameraViewController.swift
//  ShoppingApp
//
//  Created by ThiVo on 3/18/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit
import Photos
import BHPhotoView
import FirebaseMLVision

protocol TakePhotoDelegate: AnyObject {
    func pass(_ photo: UIImage)
    func fail()
}

class TakeCameraViewController: BaseViewController {
    @IBOutlet weak var cameraView: BHPhotoView!
    weak var delegate: TakePhotoDelegate?
    var recognizeType : RecognizeType = .text

    override func viewDidLoad() {
        super.viewDidLoad()
        darkMode = true
        setNeedsStatusBarAppearanceUpdate()
        self.setUpNavigationBar()

        self.cameraView.delegate = self
        self.cameraView.cameraPosition = .front
//        self.cameraView.previewOrientation = AVCaptureVideoOrientation.landscapeLeft
        self.cameraView.start()
    }
    
    @IBAction func startTake(_ sender: Any) {
        // when you call this method and photo has been taken,
        // the delegate methods will be called.
        self.cameraView.capturePhoto()
    }

    @IBAction func stopTake(_ sender: Any) {
        self.cameraView.stop()
    }

    func setUpNavigationBar(){
        self.title = "Camera"
        self.navigationController?.navigationBar.tintColor = UIColor.navigationTextColor
    }
}

extension TakeCameraViewController: BHPhotoViewDelegate {
    func onPhotoCaptured(_ view: BHPhotoView, photo: UIImage) {
        // when photo has been taken, this method will be called.
        self.delegate?.pass(photo)

        self.navigationController?.popViewController(animated: true)
    }
    
    func onPhotoCapturingError(_ view: BHPhotoView, error: BHPhotoViewError) {
        // if some error occurs, this method has been called.
        self.delegate?.fail()
        self.navigationController?.popViewController(animated: true)

    }
}

