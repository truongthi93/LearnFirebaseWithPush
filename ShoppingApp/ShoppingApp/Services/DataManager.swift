//
//  DataManager.swift
//  ShoppingApp
//
//  Created by ThiVo on 2/28/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper
import Alamofire


class DataManager: NSObject {
    
    typealias completionHandler = (AnyObject?, NSError?) -> ()
    typealias createConverSationCompletionHandler = (String?, NSError?) -> ()
    
    class var shareInstance : DataManager {
        struct Singleton {
            static let instance = DataManager()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
    }
    
    func getTrendKeywordList(completion: @escaping (_ result: Keywords?, _ error: NSError?) -> (Void)) {
        let URL = "\(Constants.AppCommon.baseURL)\(Constants.AppCommon.trendKeywordURL)"
        
        Alamofire.request(URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData { (response) in
            if let jsonData = response.result.value, let values = try? JSONDecoder().decode(Keywords.self, from: jsonData) {
                //process success
                completion(values, nil)
            } else {
                // handle error
                completion(nil, NSError(domain: "", code: 101, userInfo: nil))
            }
        }
    }
}
