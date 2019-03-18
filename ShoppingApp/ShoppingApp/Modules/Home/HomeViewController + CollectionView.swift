//
//  HomeViewController + CollectionView.swift
//  ShoppingApp
//
//  Created by ThiVo on 2/28/19.
//  Copyright © 2019 ThiVo. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.homeView.HotKeyCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.AppCommon.homeCellKey, for: indexPath) as? TrendKeywordCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of NewsTableViewCell")
        }
        
        let hotKey = self.listItem[indexPath.row]
        cell.setUpCell(data: hotKey, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hotKey = self.listItem[indexPath.row]
        return Utilities.calculateWidthForHomeView(keyword: hotKey.keyword ?? "")
    }
}
