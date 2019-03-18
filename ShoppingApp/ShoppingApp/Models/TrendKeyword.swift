//
//  TrendKeyword.swift
//  ShoppingApp
//
//  Created by ThiVo on 2/28/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import Foundation
import ObjectMapper
import FirebaseDatabase

class TrendKeyword: Decodable {
    var keyword: String?
    var icon: String?
    var id: String?

    init(id: String?, keyword: String?, icon: String?) {
        self.id = id
        self.keyword = keyword
        self.icon = icon
    }
    
    var dictionary: [String:Any] {
        return [
            "keyword" : keyword ?? "",
            "icon" : icon ?? ""
        ]
    }

    // Init for reading from Database snapshot
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        keyword = snapshotValue["keyword"] as? String
        icon = snapshotValue["icon"] as? String
    }
    
    // Func converting model for easier writing to database
    func toAnyObject() -> Any {
        return [
            "keyword": keyword,
            "icon": icon
        ]
    }
}
