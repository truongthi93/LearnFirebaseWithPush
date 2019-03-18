//
//  HomeView.swift
//  ShoppingApp
//
//  Created by ThiVo on 2/28/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit

class HomeView: UIView {
    @IBOutlet weak var HotKeyCollectionView: UICollectionView!
    @IBOutlet weak var lblUser: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
