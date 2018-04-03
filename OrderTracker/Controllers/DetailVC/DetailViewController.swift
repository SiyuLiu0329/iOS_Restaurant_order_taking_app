//
//  DetailViewController.swift
//  OrderTracker
//
//  Created by Mac on 11/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import UIKit

protocol MenuDelegate: class {
    func addItemToOrder(_ item: MenuItem)
    func quickBillItem(_ item: MenuItem)
}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var dimView: UIView!
    override var prefersStatusBarHidden: Bool {
        return true
    }


    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var menuModel: MenuModel!
    weak var delegate: MenuDelegate?
    var collectionViewDataSource: DetailCollectionViewDataSource!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewDataSource = DetailCollectionViewDataSource(data: menuModel, delegate: self)
        
        // load order from list of orders so changes can be made to the order
        
        
        itemsCollectionView.dataSource = collectionViewDataSource
        itemsCollectionView.backgroundColor = Scheme.detailViewControllerBackgoundColour
        layoutCollectionView()
        
        toolbar.barTintColor = Scheme.navigationBarColour
        toolbar.isTranslucent = true
        toolbar.tintColor = Scheme.navigationControllerBackButtonColour
        
        let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame =  (self.toolbar.bounds.insetBy(dx: -100, dy: 0).offsetBy(dx: 0, dy: 0))
        self.toolbar.isTranslucent = true
        self.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.toolbar.addSubview(visualEffectView)
    }
    
    
    
    private func layoutCollectionView() {
        let itemSpacing: CGFloat = 10
        let numberOfItemsPerRow = 3
        let width = itemsCollectionView.frame.width - CGFloat(numberOfItemsPerRow + 1) * itemSpacing
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: itemSpacing, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: width / CGFloat(numberOfItemsPerRow), height: width / CGFloat(numberOfItemsPerRow) * 1.4)
        layout.sectionInset = UIEdgeInsets(top: 54, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        itemsCollectionView.collectionViewLayout = layout
    }
    

}

extension DetailViewController: ItemCellDelegate {
    func showDetailFor(collectionViewCell cell: MenuItemCollectionViewCell) {
        let indexPath = itemsCollectionView.indexPath(for: cell)!
        let destinationVC = MenuItemExpandedViewController()
        destinationVC.menuModel = menuModel
        destinationVC.itemId = indexPath.row + 1
        destinationVC.modalPresentationStyle = .overCurrentContext
        destinationVC.view.backgroundColor = .clear
        destinationVC.delegate = delegate
        destinationVC.popoverDelegate = self // to animate dim
        destinationVC.modalTransitionStyle = .crossDissolve
        present(destinationVC, animated: true, completion: nil)
    }
    
    func quickBillItem(atCell cell: MenuItemCollectionViewCell) {
        guard let indexPath = itemsCollectionView.indexPath(for: cell) else { return }
        if delegate != nil {
            delegate!.quickBillItem(menuModel.menuItems[indexPath.row + 1]!)
        }
    }
    
    func itemAdded(atCell cell: MenuItemCollectionViewCell) {
        let indexPath = itemsCollectionView.indexPath(for: cell)!
        if delegate != nil {
            delegate!.addItemToOrder(menuModel.menuItems[indexPath.row + 1]!)
        }
    }
}

extension DetailViewController: MenuItemExpandedViewControllerDismissedDelegate {
    func popoverDidDisappear() {
        UIView.animate(withDuration: 0.2) {
            self.dimView.alpha = 0
        }
    }
    func popoverWillAppear() {
        UIView.animate(withDuration: 0.2) {
            self.dimView.alpha = 0.6
        }
    }
}

