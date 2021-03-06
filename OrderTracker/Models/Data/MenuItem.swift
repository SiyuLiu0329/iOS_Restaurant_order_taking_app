//
//  Items.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit

enum ItemType: Int, Codable {
    
    // different options for each type
    case type1
    case type1veg
    case type2
    case type3
}

enum PaymentStatus: Int, Codable {
    case paid
    case notPaid
}

struct MenuItem: Equatable, Codable {
    static func ==(lhs: MenuItem, rhs: MenuItem) -> Bool {
        guard lhs.typeHash! == rhs.typeHash! else { return false }
        return true
    }
    
    struct ThemeColour: Codable {
        var r: Double
        var g: Double
        var b: Double
        init(red r: Double, green g: Double, blue b: Double) {
            self.r = r
            self.g = g
            self.b = b
        }
    }
    
    var colour: ThemeColour
    var number: Int
    var unitPrice: Double
    var name: String
    var comment: String?
    var orderIndex: Int?
    var tableNumber: Int?
    var itemHash: String?
    var refunded = false
    var paymentStatus: PaymentStatus = .notPaid
    var served = false
    var quantity: Int
    var isInBuffer = true
    var typeHash: String?
    var totalPrice: Double {
        return unitPrice * Double(quantity)
    }
    var options: [Option] = []
    
    init(named name: String, numbered number: Int, pricedAt price: Double, typeHash hashString: String, options: [Option], colour: UIColor) {
        self.name = name
        self.number = number
        self.unitPrice =  price
        self.quantity = 1
        self.typeHash = hashString
        self.options = options
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        colour.getRed(&r, green: &g, blue: &b, alpha: nil)
        self.colour = ThemeColour(red: Double(r), green: Double(g), blue: Double(b))
    }
    
    mutating func deselectAllOptions() {
        var newOptions: [Option] = []
        options.forEach { (option) in
            var op = option
            op.value = false
            newOptions.append(op)
        }
        options = newOptions
    }
    
    func getImage() -> UIImage {
        return #imageLiteral(resourceName: "placeholder")
    }
    
    mutating func addOption(_ option: Option) {
        options.append(option)
    }
    
    mutating func changePaymentStatus(to status: PaymentStatus) {
        paymentStatus = status
    }
    
    mutating func addCustomOption(option: Option) {
        options.append(option)
        unitPrice += option.price
    }
    
    mutating func toggleSelectetState(ofOption index: Int) {
        options[index].value = !options[index].value
        unitPrice += (options[index].value) ? options[index].price : -options[index].price
    }
}
