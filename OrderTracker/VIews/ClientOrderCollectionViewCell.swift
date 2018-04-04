//
//  ClientOrderCollectionViewCell.swift
//  OrderTracker
//
//  Created by Siyu Liu on 4/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class ClientOrderCollectionViewCell: UICollectionViewCell {
//
    @IBOutlet weak var headerViewTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var order: Order!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = Scheme.clientOrderCollectionViewCellColour
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ClientItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = Scheme.clientOrderCollectionViewCellColour
        headerView.backgroundColor = Scheme.clientOrderCollectionViewCellColour
        
    }
    
    func configure(loadingOrder order: Order) {
        headerViewTitle.text = "Order \(order.orderNumber)"
        self.order = order
        collectionView.reloadSections([0])
    }

}

extension ClientOrderCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order.itemCollections[0].count + order.itemCollections[1].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ClientItemCollectionViewCell
        let numberOfPendingItems = order.itemCollections[0].count
        if indexPath.row < numberOfPendingItems {
            cell.backgroundColor = .blue
        } else {
            let fetchIndexOfPaidItem = indexPath.row - numberOfPendingItems
            cell.backgroundColor = .red
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
    }
}
