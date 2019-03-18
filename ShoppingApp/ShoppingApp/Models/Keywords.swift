//
//  Keywords.swift
//  ShoppingApp
//
//  Created by ThiVo on 2/28/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import Foundation
import ObjectMapper

class Keywords: Decodable {
    var keywords: [TrendKeyword]?
    
    init(keywords: [TrendKeyword]?) {
        self.keywords = keywords
    }
}
