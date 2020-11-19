//
//  ItemsViewController.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit

class ItemsViewController: CardDetailVC, UITableViewDelegate, UITableViewDataSource, RequestItemCellProtocol {
    
    var titleText: String = ""
    var delegate: RequestItemHandler?
    var items: [RequestItem]?
    var basketItems: [RequestItem]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardTitle.text = titleText
        
        cardTableView.delegate = self
        cardTableView.dataSource = self
        RequestItemCell.register(for: cardTableView)
        
        items = []
        items?.append(.init(name: "Test", icon: "", qty: 0, bgCol: ""))
        cardTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = RequestItemCell.buildInstance(for: cardTableView, delegate: self, title: "Eggs", icon: "") {
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func updateCount(for cell: RequestItemCell, modifier: Int) {
        guard let index = cardTableView.indexPath(for: cell)?.row else {
            return
        }
        
        guard let item = items?[index] else {
            return
        }
        
        if modifier > 0 {
            if cell.count == 0 {
                if delegate != nil {
                    delegate?.addItem(item: item)
                }
            }
        } else {
            if cell.count > 0 {
                if delegate != nil {
                    delegate?.removeItem(item: item)
                }
            }
        }
        item.qty += modifier
        cell.count += modifier
        delegate?.updateItemCount(item: item, newCount: item.qty)
    }
    
    func plusClicked(for cell: RequestItemCell) {
        updateCount(for: cell, modifier: 1)
    }
    
    func minusClicked(for cell: RequestItemCell) {
        updateCount(for: cell, modifier: -1)
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
