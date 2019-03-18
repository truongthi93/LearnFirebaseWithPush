//
//  NewProductViewController.swift
//  ShoppingApp
//
//  Created by ThiVo on 3/7/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth

class NewProductViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imvProduct: UIImageView!
    
    var imagePicker = UIImagePickerController()

    fileprivate var storageImagePath = ""
    fileprivate var storageUploadTask: StorageUploadTask!
    fileprivate var showNetworkActivityIndicator = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = showNetworkActivityIndicator
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        darkMode = true
        setNeedsStatusBarAppearanceUpdate()
        self.setUpNavigationBar()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUpNavigationBar(){
        self.title = Constants.AppCommon.addProductTitle
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.save,
            target: self,
            action: #selector(addNewProduct)
        )
    }

    fileprivate func getKeywordsDatabase(_ keyword: TrendKeyword) {
        // Access the "unicorns" child reference and then access (create) a unique child reference within it and finally set its value
        self.databaseRef.child("TrendKeyword").child("\(Int(Date.timeIntervalSinceReferenceDate * 1000))").setValue(keyword.toAnyObject())
    }
    
    @objc func addNewProduct(sender: UIButton!) {
        let name = tfProductName.text
        let img = UIImage(named: "vietnam")
        
        if name != "" && img != nil {
            
            // Get properties for the unicorn-to-be-created
            getKeywordsDatabase(TrendKeyword(id: "", keyword: name, icon: storageImagePath))
            self.navigationController?.popViewController(animated: true)

        } else {
            let btnOK = UIAlertAction(title: NSLocalizedString(Constants.AppCommon.OK, comment: ""), style: .cancel, handler: nil)
            btnOK.setValue(UIColor.black, forKey: Constants.AppCommon.titleTextColor)
            Utilities.showAlert(title: Constants.AppCommon.info, message: Constants.Info.infoMissing, buttons: [btnOK], context: self)
        }
    }
    
    @IBAction func btnChangeImageClick(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            //imag.mediaTypes = [kUTTypeImage];
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // 1. Get image data from selected image
        guard let image = info[.originalImage] as? UIImage,
            let imageData = image.jpegData(compressionQuality: 0.5) else {
                print("Could not get Image JPEG Representation")
                return
        }
        
        // 2. Create a unique image path for image. In the case I am using the googleAppId of my account appended to the interval between 00:00:00 UTC on 1 January 2001 and the current date and time as an Integer and then I append .jpg. You can use whatever you prefer as long as it ends up unique.
        let imagePath = Auth.auth().app!.options.googleAppID + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        // 3. Set up metadata with appropriate content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // 4. Show activity indicator
        showNetworkActivityIndicator = true
        
        // 5. Start upload task
        storageUploadTask = storageRef.child(imagePath).putData(imageData, metadata: metadata) { (_, error) in
            // 6. Hide activity indicator because uploading is done with or without an error
            self.showNetworkActivityIndicator = false
            
            guard error == nil else {
                print("Error uploading: \(error!)")
                return
            }
            self.uploadSuccess(imagePath, image)
        }
    }

    fileprivate func uploadSuccess(_ storagePath: String, _ storageImage: UIImage) {
        // Update the unicorn image view with the selected image
        imvProduct.image = storageImage
        // Updated global variable for the storage path for the selected image
        storageImagePath = storagePath
    }
}
