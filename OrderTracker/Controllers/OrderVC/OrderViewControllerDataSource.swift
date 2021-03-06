//
//  File.swift
//  OrderTracker
//
//  Created by Siyu Liu on 19/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class OrderViewControllerDataSource: NSObject, UICollectionViewDataSource {
    var orderModel: OrderModel
    var collectionView: UICollectionView!
    init(data orderModel: OrderModel) {
        
        self.orderModel = orderModel
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderModel.allOrders.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: OrderCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as! OrderCollectionViewCell
        cell.configure()
        if indexPath.row == orderModel.allOrders.count {
            cell.label.text = "New Order"
            cell.deleteButton.alpha = 0
        } else if indexPath.row == orderModel.allOrders.count - 1 {
            cell.label.text = "\(orderModel.allOrders[indexPath.row].orderNumber)"
            cell.deleteButton.alpha = 1
        } else {
            cell.label.text = "\(orderModel.allOrders[indexPath.row].orderNumber)"
            cell.deleteButton.alpha = 0
        }
        cell.delegate = self
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

extension OrderViewControllerDataSource: OrderCollectionViewCellDelegate {
    func deleteOrder(_ sender: OrderCollectionViewCell) {
        orderModel.deleteLastestOrder()
        collectionView.deleteItems(at: [IndexPath(item: orderModel.allOrders.count, section: 0)])
        if orderModel.allOrders.count > 0 {
            collectionView.reloadItems(at: [IndexPath(item: orderModel.allOrders.count - 1, section: 0)])
        }
    }
}
