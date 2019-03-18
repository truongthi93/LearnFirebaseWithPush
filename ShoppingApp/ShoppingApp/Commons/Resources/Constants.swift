//
//  Constants.swift
//  ShoppingApp
//
//  Created by ThiVo on 2/28/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

class Constants {
    public class AppCommon {
        static let baseURL = "https://tiki-mobile.s3-ap-southeast-1.amazonaws.com/ios/"
        static let trendKeywordURL = "keywords.json"
        static let homeTitle = "Home"
        static let addProductTitle = "Add New Product"
        static let info = "Info"
        static let tagIndicator = 100
        static let OK = "OK"
        static let titleTextColor = "titleTextColor"
        static let homeCellKey = "TrendKeywordCollectionViewCell"
    }
    
    public class Info {
        static let infoData = "Name: Thi Vo\nPhone: 0376137185\nEmail: truongthi93@gmail.com"
        static let infoMissing = "Some data is misssing.\nPlease check and try againt"
    }
    
    public class Size{
        static let homeCellHeight = 180
        static let homeCellMinWidth = 112
    }
}
