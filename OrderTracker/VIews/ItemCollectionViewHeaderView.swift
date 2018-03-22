//
//  ItemCollectionViewHeaderView.swift
//  OrderTracker
//
//  Created by Mac on 14/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

class ItemCollectionViewHeaderView: UICollectionReusableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Scheme.collectionViewBackGroundColour
    }
}