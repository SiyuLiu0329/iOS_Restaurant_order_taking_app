//
//  PaymentMethodChooserViewController.swift
//  OrderTracker
//
//  Created by Siyu Liu on 1/4/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

class PaymentMethodChooserViewController: UIViewController {
    @IBAction func CancelButtonPressed(_ sender: Any) {
        confirmButton.isEnabled = false
        cancelButton.isEnabled = false
        cashLabel.textColor = .darkGray
        cardLabel.textColor = .darkGray
        cardViewWidth.constant = fullWidth / 2
        UIView.animate(withDuration: 0.3) {
            self.cashView.alpha = 1
            self.cardView.alpha = 1
            self.view.layoutIfNeeded()
            self.cardView.backgroundColor = .white
            self.cashView.backgroundColor = .white
        }
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {

    }
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cashLabel: UILabel!
    @IBOutlet weak var cardViewWidth: NSLayoutConstraint!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cashView: UIView!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cashImageView: UIImageView!
    private var cashViewTapGestureRecogniser: UITapGestureRecognizer!
    private var cardViewTapGestureRecogniser: UITapGestureRecognizer!
    private var cashSelected = true
    private var fullWidth: CGFloat!
    weak var delegate: BillCellDelegate? // this delegate is passed in through the data source
    
    private func addRoundedCorner(toSubview view: UIView, withRadius radius: CGFloat) {
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fullWidth = 540
        cardViewWidth.constant = fullWidth / 2
        cardImageView.image = #imageLiteral(resourceName: "card")
        cardImageView.alpha = 0.8
        cashImageView.image = #imageLiteral(resourceName: "cash")
        cashImageView.alpha = 0.8
        addRoundedCorner(toSubview: cardImageView, withRadius: 20)
        addRoundedCorner(toSubview: cashImageView, withRadius: 20)
        cardImageView.backgroundColor = .white
        cashImageView.backgroundColor = .white
        
        // buttons cannot be pressed without having a choosen payment method
        confirmButton.isEnabled = false
        cancelButton.isEnabled = false
        cashViewTapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.tapped(sender:)))
        cashView.addGestureRecognizer(cashViewTapGestureRecogniser)
        
        cardViewTapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.tapped(sender:)))
        cardView.addGestureRecognizer(cardViewTapGestureRecogniser)
        
    }
    
    @objc func tapped(sender genstureRecogniser: UITapGestureRecognizer) {
        if genstureRecogniser == cashViewTapGestureRecogniser {
            // cash
            cardViewWidth.constant = 0 // expand the view to the right
            UIView.animate(withDuration: 0.3) {
                self.cardView.alpha = 0
                self.cashView.backgroundColor = Scheme.billViewCashSelectedColour
                self.cardView.backgroundColor = .white
                self.view.layoutIfNeeded() // animate the expansion
            }
            // restore labels
            cashLabel.textColor = .white
            cardLabel.textColor = .darkGray
            cashSelected = true
            
        } else if genstureRecogniser == cardViewTapGestureRecogniser {
            // card
            cardViewWidth.constant = fullWidth
            UIView.animate(withDuration: 0.3) {
                self.cashView.alpha = 0
                self.cardView.backgroundColor = Scheme.billViewCardSelectedColour
                self.cashView.backgroundColor = .white
                self.view.layoutIfNeeded()
            }
            
            cashLabel.textColor = .darkGray
            cardLabel.textColor = .white
            cashSelected =  false
            
        } else {
            // this should never happen!
            fatalError()
        }
        
        confirmButton.isEnabled = true
        cancelButton.isEnabled = true
        
    }

}
