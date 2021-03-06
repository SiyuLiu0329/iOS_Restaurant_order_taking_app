//
//  ClientViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 3/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ClientOrderViewDelegate: class {
    func didUpdateItem(inOrderwithIndex orderIndex: Int, itemWithIndex itemIndex: Int, shouldAddNewOrder newOrder: Bool, isItemInserted inserted: Bool)
    func didDeleteItem(inOrderwithIndex orderIndex: Int, itemWithIndex itemIndex: Int)
    func didDeleteLastestOrder(indexed index: Int)
    func didAddEmptyOrder(indexed index: Int)
    func reloadOrder(orderIndex index: Int)
}

class ClientViewController: UIViewController {
    @IBOutlet weak var clientOrderCollectionView: UICollectionView!
    
    var clientModel: ClientModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Scheme.collectionViewBackGroundColour
        clientOrderCollectionView.backgroundColor = Scheme.collectionViewBackGroundColour
        let billAllCellNib = UINib(nibName: "ClientOrderCollectionViewCell", bundle: Bundle.main)
        clientOrderCollectionView.register(billAllCellNib, forCellWithReuseIdentifier: "clientOrderCell")
        clientOrderCollectionView.delegate = self
        clientOrderCollectionView.dataSource = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ClientViewController: ClientOrderViewDelegate {
    func didUpdateItem(inOrderwithIndex orderIndex: Int, itemWithIndex itemIndex: Int, shouldAddNewOrder newOrder: Bool, isItemInserted inserted: Bool) {
        if newOrder {
            clientOrderCollectionView.insertItems(at: [IndexPath(item: orderIndex, section: 0)])
            // deprecate this later
        } else {
            if let cell = clientOrderCollectionView.cellForItem(at: IndexPath(item: orderIndex, section: 0)) as? ClientOrderCollectionViewCell {
                // if cell is visible
                cell.configure(loadingOrder: clientModel.orders[orderIndex])
                if inserted {
                    cell.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: 0)])
                } else {
                    cell.collectionView.reloadItems(at: [IndexPath(item: itemIndex, section: 0)])
                }
                
            } else {
                clientOrderCollectionView.reloadItems(at: [IndexPath(item: orderIndex, section: 0)])
            }
        }
    }
    
    
    func reloadOrder(orderIndex index: Int) {
        clientOrderCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func didDeleteItem(inOrderwithIndex orderIndex: Int, itemWithIndex itemIndex: Int) {
        if let cell = clientOrderCollectionView.cellForItem(at: IndexPath(item: orderIndex, section: 0)) as? ClientOrderCollectionViewCell {
            // if cell is visible
            cell.configure(loadingOrder: clientModel.orders[orderIndex])
            cell.collectionView.deleteItems(at: [IndexPath(item: itemIndex, section: 0)])
        } else {
            clientOrderCollectionView.reloadItems(at: [IndexPath(item: orderIndex, section: 0)])
        }
    }
    
    func didDeleteLastestOrder(indexed index: Int) {
        clientOrderCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func didAddEmptyOrder(indexed index: Int) {
        clientOrderCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
    }
    
}

extension ClientViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(clientModel.orders.count)
        return clientModel.orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clientOrderCell", for: indexPath) as! ClientOrderCollectionViewCell
        cell.configure(loadingOrder: clientModel.orders[indexPath.row])
        cell.delegate = self
        cell.collectionView.reloadData() // refresh data when cell becomes visible again
        return cell
    }
    
    
    
    // layout options
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 20
        let width = collectionView.frame.width / 3 - 13
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension ClientViewController: ClientItemCollectionViewCellDelegate {
    func didSelectItem(atIndex index: Int, inOrder orderIndex: Int) {
        clientModel.requestFinishItem(indexed: index, inOrder: orderIndex)
    }
}

