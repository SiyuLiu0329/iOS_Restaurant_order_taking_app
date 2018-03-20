//
//  DetailCollectionViewDataSource.swift
//  OrderTracker
//
//  Created by Siyu Liu on 19/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

protocol MenuItemSelectedDelegate: class {
    func itemDidGetSelected(itemAt indexPath: IndexPath, in view: UICollectionView)
}

class DetailCollectionViewDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var orderList: OrderList
    weak var itemSelectedDelegate: MenuItemSelectedDelegate?
    var delegateVC: ItemCellDelegate?
    init(data orderList: OrderList, delegate delegateVC: ItemCellDelegate) {
        self.orderList = orderList
        self.delegateVC = delegateVC
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList.menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = orderList.menuItems[indexPath.row + 1] else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuItemCollectionViewCell
        cell.delegate = delegateVC!
        cell.configure(imgUrl: item.imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if itemSelectedDelegate != nil {
            itemSelectedDelegate!.itemDidGetSelected(itemAt: indexPath, in: collectionView)
        }
    }

}

