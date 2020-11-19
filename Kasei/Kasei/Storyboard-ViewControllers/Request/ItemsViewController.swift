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
    var delegate: RequestItemHandler?
    var itemIDs = [String]()
    var items = [RequestItem]()
    var basketItems = [RequestItem]()
    
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
                    self.loadBasket()
                    self.cardTableView.reloadData()
                }
            }
        }
    }
    
    func loadBasket() {
        for item in items {
            for basketItem in basketItems {
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
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func plusClicked(for cell: RequestItemCell) {
        updateCountForItemHandler(for: cardTableView, with: delegate, using: cell, items: items, modifier: 1)
    }
    
    func minusClicked(for cell: RequestItemCell) {
        updateCountForItemHandler(for: cardTableView, with: delegate, using: cell, items: items, modifier: -1)
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
