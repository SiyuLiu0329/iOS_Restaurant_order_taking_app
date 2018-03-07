//
//  CollectionViewCell.swift
//  OrderTracker
//
//  Created by macOS on 22/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol optionButtonDelegate: class {
    func optionaButtonPressed(_ sender: Any)
}

class OptionCollectionViewCell: UICollectionViewCell {
    weak var delegate: optionButtonDelegate?
    
    @IBOutlet weak var checkMark: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var toggleButton: UIButton!
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.optionaButtonPressed(self)
    }
    
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
        overlay.alpha = 0.3
        checkMark.alpha = 0
    }
    
    func light() {
        overlay.alpha = 0.05
        checkMark.alpha = 1
    }
}