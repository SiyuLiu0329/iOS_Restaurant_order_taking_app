//
//  DetailViewController.swift
//  OrderTracker
//
//  Created by macOS on 20/2/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
    var orderList: OrderList!
    var itemNumber: Int?
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var item: MenuItem? {
        didSet {
            itemNumber = item?.number
            refreshUI()
        }
    }
    
    func refreshUI() {
        loadViewIfNeeded()
        guard let currentItem = item else { return }
        itemImage.image = UIImage(named: currentItem.imageURL)
        navigationController?.navigationBar.topItem?.title = currentItem.name
        quantity.text = String(describing: currentItem.quantity)
        priceLabel.text = "$" + String(describing: currentItem.totalPrice)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cCell", for: indexPath) as! CollectionViewCell
        cell.label.text = String(describing: indexPath)
        return cell
    }
}


extension DetailViewController {
    // Button actions
    @IBAction func btnIncrementQuantity(_ sender: Any) {
        guard item != nil,
            orderList.menuItems[item!.number] != nil,
            itemNumber != nil else { return }
        orderList.incrementQuantity(forItem: itemNumber!, by: 1)
        quantity.text = String(describing: orderList.menuItems[itemNumber!]!.quantity)
        priceLabel.text = "$" + String(describing: orderList.menuItems[itemNumber!]!.totalPrice)
    }
    
    @IBAction func btnDecrementQuantity(_ sender: Any) {
        guard item != nil,
            orderList.menuItems[item!.number] != nil,
            itemNumber != nil else { return }
        orderList.incrementQuantity(forItem: itemNumber!, by: -1)
        quantity.text = String(describing: orderList.menuItems[itemNumber!]!.quantity)
        priceLabel.text = "$" + String(describing: orderList.menuItems[itemNumber!]!.totalPrice)
    }
    
    @IBAction func btnAddOrder(_ sender: Any) {
        guard itemNumber != nil,
            orderList.menuItems[itemNumber!]!.totalPrice != 0 else { return }
        orderList.addItem(itemNumber: itemNumber!)
        item = orderList.menuItems[itemNumber!]
    }
}
