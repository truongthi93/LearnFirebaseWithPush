//
//  Codeable.swift
//  ShoppingApp
//
//  Created by ThiVo on 3/15/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit

extension Encodable {
    /// Returns a JSON dictionary, with choice of minimal information
    func getDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any]
        }
    }
}

extension Decodable {
    /// Initialize from JSON Dictionary. Return nil on failure
    init?(dictionary value: [String:Any]){
        
        guard JSONSerialization.isValidJSONObject(value) else { return nil }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) else { return nil }
        
        guard let newValue = try? JSONDecoder().decode(Self.self, from: jsonData) else { return nil }
        self = newValue
    }
}

