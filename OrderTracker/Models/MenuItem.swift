//
//  Items.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

enum ItemType {
    // different options for each type
    case type1
    case type1veg
    case type2
    case type3
}

struct MenuItem {
    var number: Int
    var unitPrice: Double {
        willSet {
            totalPrice = newValue * Double(quantity)
        }
    }
    var name: String
    var comment: String?
    var imageURL: String
    var tableNumber: Int?
    var itemType: ItemType
    
    var quantity: Int {
        willSet {
            totalPrice = Double(newValue) * unitPrice
        }
    }
    
    var totalPrice: Double
    var options: [Option] = []
    
    init(named name: String, numbered number: Int, itemType type: ItemType, pricedAt price: Double, image imageName: String) {
        self.name = name
        self.number = number
        self.unitPrice =  price
        self.imageURL = imageName
        self.quantity = 0
        self.totalPrice = 0
        self.itemType = type
        addDefaultOptions()
    }
    
    mutating private func addDefaultOptions() {
        options = addDefaultOptionsUtl(for: itemType)
    }
    
    mutating func addOption(_ option: Option) {
        options.append(option)
    }
}
