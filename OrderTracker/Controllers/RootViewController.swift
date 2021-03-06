
//  rootViewController.swift
//  OrderTracker
//
//  Created by macOS on 7/3/18.
//  Copyright © 2018 macOS. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class RootViewController: UIViewController {
    
    var connectionHandler = ConnectionHandler()
    weak var delegate: ClientOrderViewDelegate?
    @IBOutlet weak var joinButton: UIButton!
    
    @IBAction func joinButtonPressed(_ sender: Any) {
        present(connectionHandler.browser, animated: true, completion: nil)
        connectionHandler.isServer = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        connectionHandler.browser.delegate = self
        connectionHandler.session.delegate = self
        showOrderButton.alpha = 0
    }
    
    @IBOutlet weak var showOrderButton: UIButton!
    
    let orderModel = OrderModel()
    let clientModel = ClientModel()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rootSegue1" {
            UIBarButtonItem.appearance().setTitleTextAttributes(Scheme.AttributedText.navigationControllerTitleAttributes, for: .normal) // this affects all bar buttons
            let navVC = segue.destination as! UINavigationController
            navVC.navigationBar.barTintColor = Scheme.navigationBarColour
            let orderVC = navVC.viewControllers.first as! OrderViewController
            orderVC.orderModel = orderModel
        } else if segue.identifier == "rootViewSegue2" {
            let clientVC = segue.destination as! ClientViewController
            clientVC.clientModel = clientModel
            delegate = clientVC
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension RootViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        joinButton.setTitle("Client", for: .normal)
        joinButton.isUserInteractionEnabled = false
        showOrderButton.alpha = 1
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
        connectionHandler.isServer = true
    }
}

extension RootViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("connected: \(peerID.displayName)")
            if !connectionHandler.isServer {
                clientModel.session = connectionHandler.session
                // this is the client
                do {
                    let data = try JSONEncoder().encode(CommunicationProtocol(containingItems: nil, numberOfOrders: nil, ofMessageType: .clientReportConnected))
                    try connectionHandler.session.send(data, toPeers: connectionHandler.session.connectedPeers, with: .reliable)
                } catch let error {
                    print(error)
                }
            }
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            // disconnected
            print("disconnected")
            // fatal error
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let message = try JSONDecoder().decode(CommunicationProtocol.self, from: data)
            DispatchQueue.main.async {
                switch message.type {
                case .serverToClientItemUpdate:
                    let items = message.items!
                    let insertionResult =  self.clientModel.reciveItemsFromServer(items, numberOfOrders: message.numberOfOrders!)
                    if insertionResult == nil {
                        return
                    }
                    let insertionIndex = insertionResult!.insertionIndex
                    let insertedOrderIndex = items.first!.orderIndex
                    if  self.delegate != nil {
                        self.delegate!.didUpdateItem(inOrderwithIndex: insertedOrderIndex!, itemWithIndex: insertionIndex, shouldAddNewOrder: insertionResult!.isNewOrder, isItemInserted: insertionResult!.isItemInserted)
                    }
                    
                case .serverDidDeleteItem:
                    let item = message.items!.first!
                    guard let deleteIndex =  self.clientModel.deleteItem(item) else { fatalError() }
                    if  self.delegate != nil {
                        
                        self.delegate!.didDeleteItem(inOrderwithIndex: item.orderIndex!, itemWithIndex: deleteIndex)
                        
                    }
                    
                case .addEmptyOrder:
                    self.clientModel.addEmptyOrder(numbered: message.numberOfOrders! + 1)
                    if self.delegate != nil {
                        self.delegate!.didAddEmptyOrder(indexed: self.clientModel.orders.count - 1)
                    }
                    
                case .clientReportConnected:
                    if self.connectionHandler.isServer {
                        self.orderModel.session = self.connectionHandler.session
                        self.orderModel.sendInitalOrders()
                        self.joinButton.setTitle("Sever", for: .normal)
                        self.joinButton.isUserInteractionEnabled = false
                    }
                    
                case .clientRequestItemFinish:
                    _ = self.orderModel.markItemAsServed(message.items!.first!)
                    
                case .clearOrder:
                    self.clientModel.clearOrder(indexed: message.orderToModify!)
                    if self.delegate != nil {
                        self.delegate!.reloadOrder(orderIndex: message.orderToModify!)
                    }
                    
                case .deleteLastedOrder:
                    self.clientModel.deleteLastestOrder()
                    if self.delegate != nil {
                        self.delegate!.didDeleteLastestOrder(indexed: self.clientModel.orders.count)
                    }
                default:
                    break
                }
            }
            
        } catch {
            //            print(error)
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // not needed
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // not needed
    }
}
