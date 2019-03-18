//
//  Utilitys.swift
//  ShoppingApp
//
//  Created by ThiVo on 2/28/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase //tried not having this line, still the same
import FirebaseStorage //tried not having this line, still the same

class Utilities {
    class func showAlert(title: String,message: String,buttons: [UIAlertAction],context: UIViewController) {
        let tempMessage = message
        let alert = UIAlertController(title: title, message: tempMessage, preferredStyle: .alert)
        for button in buttons {
            alert.addAction(button)
        }
        context.present(alert, animated: true, completion: nil)
    }

    class func showIndicator(view: UIView) {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.center = view.center
        indicator.tag = Constants.AppCommon.tagIndicator
        view.isUserInteractionEnabled = false
        view.addSubview(indicator)
        indicator.startAnimating()
    }

    class func hideIndicator(view: UIView) {
        for subView in view.subviews {
            if subView.tag == Constants.AppCommon.tagIndicator {
                (subView as! UIActivityIndicatorView).stopAnimating()
                subView.removeFromSuperview()
                view.isUserInteractionEnabled = true
            }
        }
    }
    
    class func downloadImage(from url: URL , success:@escaping((_ image:UIImage)->()),failure:@escaping ((_ msg:String)->())){
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                failure("Image cant download from G+ or fb server")
                return
            }
            
            //print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                if let _img = UIImage(data: data){
                    success(_img)
                }
            }
        }
    }
    
    class func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // #16702e, #005a51, #996c00, #5c0a6b, #006d90, #974e06, #99272e, #89221f, #00345d // 9 colors
    class func getColorForHomeViewCell(index: Int) -> UIColor {
        let i = index % 9
        let arrayColor = [UIColor.init(hexFromString: "#16702e"),
                          UIColor.init(hexFromString: "#005a51"),
                          UIColor.init(hexFromString: "#996c00"),
                          UIColor.init(hexFromString: "#5c0a6b"),
                          UIColor.init(hexFromString: "#006d90"),
                          UIColor.init(hexFromString: "#974e06"),
                          UIColor.init(hexFromString: "#99272e"),
                          UIColor.init(hexFromString: "#89221f"),
                          UIColor.init(hexFromString: "#00345d")]
        return arrayColor[i]
    }

    class func calculateWidthForHomeView(keyword: String) -> CGSize{
        // Get size for label in 1 line
        let size = keyword.size(withAttributes:[.font: UIFont.systemFont(ofSize:14.0)])
        let wordsCount = self.calculateNumberOfWordInText(keyword: keyword)
        
        let doulePadding = CGFloat(8.0) // Left and right padding
        if (size.width + doulePadding) <= CGFloat(Constants.Size.homeCellMinWidth) {
            if wordsCount < 2{
                // return width is 112
                return CGSize(width: Constants.Size.homeCellMinWidth, height: Constants.Size.homeCellHeight)
            } else {
                // return width is 112 but in show text in 2 line
                return CGSize(width: Constants.Size.homeCellMinWidth, height: Constants.Size.homeCellHeight)
            }
        } else {
            /*return width is size of text / 2 (line). But Now I haven't find the best solution for calculate correct to minimum the width of cell. In this case I multipled with a estimated number because text in line1 and 2 is not the same. In this case, I used 1.35 and check OK.*/
            return CGSize(width: (size.width + doulePadding)/2 * 1.35, height: CGFloat(Constants.Size.homeCellHeight))
        }
    }
    
    class func calculateNumberOfWordInText(keyword: String) -> Int{
        // Get number of word (Not include special character)
        let components = keyword.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        return words.count
    }
    
    class func makeDouleLineForShortText(keyword: String) -> String{
        // Get size for label in 1 line
        let size = keyword.size(withAttributes:[.font: UIFont.systemFont(ofSize:14.0)])
        let wordsCount = self.calculateNumberOfWordInText(keyword: keyword)
        
        let doulePadding = CGFloat(8.0) // Left and right padding
        if (size.width + doulePadding) <= CGFloat(Constants.Size.homeCellMinWidth) {
            if wordsCount < 2{
                return keyword
            } else {
                return self.addNewLine(keyword: keyword)
            }
        } else {
            return keyword
        }
    }

    class func addNewLine(keyword: String) -> String{
        let components = keyword.components(separatedBy: .whitespacesAndNewlines)
        var result = ""
        for index in 0...(components.count - 1){
            if index == 0 {
                result += (components[index] + "\n")
            } else if index == (components.count - 1){
                result += components[index]
            } else {
                result += (components[index] + " ")
            }
        }
        return result
    }
    
    class func downloadImage(from storageImagePath: String, completion: @escaping (UIImage?) -> ()) {
        // 1. Get a filePath to save the image at
        var storageRef: StorageReference!
        storageRef = Storage.storage().reference()
        var storageDownloadTask: StorageDownloadTask!

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filePath = "file:\(documentsDirectory)/myimage.jpg"
        // 2. Get the url of that file path
        guard let fileURL = URL(string: filePath) else {
            return completion(nil)
        }
        // 3. Start download of image and write it to the file url
        storageDownloadTask = storageRef.child(storageImagePath).write(toFile: fileURL, completion: { (url, error) in
            // 4. Check for error
            if let error = error {
                print("Error downloading:\(error)")
                return completion(nil)
                // 5. Get the url path of the image
            } else if let imagePath = url?.path {
                // 6. Update the unicornImageView image
                return completion(UIImage(contentsOfFile: imagePath))
            }
        })
        // 7. Finish download of image
    }
}
