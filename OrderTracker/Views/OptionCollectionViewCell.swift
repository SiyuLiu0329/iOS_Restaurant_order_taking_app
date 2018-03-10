//
//  CollectionViewCell.swift
//  OrderTracker
//
//  Created by macOS on 22/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit


class OptionCollectionViewCell: UICollectionViewCell {
    
    func configureCell(description des: String) {
        layer.cornerRadius = 5
        clipsToBounds = true
        optionDescription.text = des
    }
    
    @IBOutlet weak var optionDescription: UILabel!
    var toggleState: Bool = false {
        willSet {
            if newValue == true {
                light()
            } else {
                dim()
            }
        }
    }
    
    func dim() {
        backgroundColor = .clear
    }
    
    func light() {
        backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }
}
