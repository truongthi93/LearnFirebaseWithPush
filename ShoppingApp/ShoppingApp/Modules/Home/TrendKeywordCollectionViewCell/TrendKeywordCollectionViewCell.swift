//
//  TrendKeywordCollectionViewCell.swift
//  ShoppingApp
//
//  Created by ThiVo on 2/28/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit

class TrendKeywordCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imvHotKey: UIImageView!
    @IBOutlet weak var lblHotKey: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(data: TrendKeyword, index: Int){
        self.bottomView.backgroundColor = Utilities.getColorForHomeViewCell(index: index)
        self.lblHotKey.text = Utilities.makeDouleLineForShortText(keyword: data.keyword ?? "")
        
        if let urlString = data.icon, urlString != "", let url = URL(string: urlString) {
            // Download from URL
            /*Utilities.downloadImage(from:url , success: { (image) in
             //print(image)
             self.imvHotKey.image = image
             }, failure: { (failureReason) in
             // show error
             self.imvHotKey.image = UIImage(named: "vietnam")
             //print(failureReason)
             })*/
            
            // Download from Storage Firebase
            Utilities.downloadImage(from: urlString) { (image) in
                //print(image)
                if let img = image{
                    self.imvHotKey.image = img
                } else {
                    self.imvHotKey.image = UIImage(named: "vietnam")
                }
            }
        } else {
            self.imvHotKey.image = UIImage(named: "vietnam")
        }
    }
}
