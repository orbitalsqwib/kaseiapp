//
//  ItemsViewController.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit
import FirebaseDatabase

class ItemsViewController: CardDetailVC, UITableViewDelegate, UITableViewDataSource, RequestItemCellProtocol {
    
    var titleText: String = ""
    weak var itemViewDelegate: RequestItemViewProtocol?
    weak var basketDelegate: BasketHandlerProtocol?
    var itemIDs = [String]()
    var items = [RequestItem]()
    
    let DBRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardTitle.text = titleText
        
        cardTableView.delegate = self
        cardTableView.dataSource = self
        RequestItemCell.register(for: cardTableView)
        loadItems()
        cardTableView.reloadData()
    }
    
    func loadItems() {
        var counter = itemIDs.count
        for id in itemIDs {
            getRequestItem(DBRef: DBRef, forID: id) { (item) in
                if item != nil {
                    self.items.append(item!)
                }
                counter -= 1
                if counter == 0 {
                    self.updateItemsFromBasket()
                    self.cardTableView.reloadData()
                }
            }
        }
    }
    
    func updateItemsFromBasket() {
        guard let delegate = basketDelegate else {
            return
        }
        
        for item in items {
            for basketItem in delegate.retrieveItems() {
                if item.name == basketItem.name {
                    item.qty = basketItem.qty
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        if let cell = RequestItemCell.buildInstance(for: cardTableView, delegate: self, title: item.name, icon: item.icon) {
            cell.count = item.qty
            cell.maxCount = min(item.qtyLimit ?? 99, item.qtyRemaining ?? 99)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func plusClicked(for cell: RequestItemCell) {
        guard let item = getItem(for: cell, in: cardTableView, with: items) else {
            return
        }
        
        basketDelegate?.update(item: item, modifier: 1, updateItems: { (updatedItems) in
            if let viewDelegate = self.itemViewDelegate {
                viewDelegate.updateView(with: updatedItems)
            }
            
            self.updateItemsFromBasket()
            self.cardTableView.reloadData()
        })
    }
    
    func minusClicked(for cell: RequestItemCell) {
        guard let item = getItem(for: cell, in: cardTableView, with: items) else {
            return
        }
        
        basketDelegate?.update(item: item, modifier: -1, updateItems: { (updatedItems) in
            if let viewDelegate = self.itemViewDelegate {
                viewDelegate.updateView(with: updatedItems)
            }
            
            self.updateItemsFromBasket()
            self.cardTableView.reloadData()
        })
    }
    
    func cellTapped(for cell: RequestItemCell) { }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
