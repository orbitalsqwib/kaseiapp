//
//  NewRequestViewController.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit

class NewRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewItemCellProtocol, RequestItemCellProtocol, RequestItemHandler {

    @IBOutlet weak var requestItemsTableView: UITableView!
    @IBOutlet weak var actionBar: UIView!
    @IBOutlet weak var checkoutBtn: UIButton!
    
    var newRequest: Request?
    
    let authHandler = FirAuthHandler.self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        requestItemsTableView.delegate = self
        requestItemsTableView.dataSource = self
        NewItemCell.register(for: requestItemsTableView)
        RequestItemCell.register(for: requestItemsTableView)
        
        // make action bar cooler
        actionBar.setShadow(col: UIColor.lightGray.cgColor, opacity: 0.5, offset: .zero, rad: 4)
        traitCollectionDidChange(nil)
        
        // add insets for scroll view to avoid obscuring button
        requestItemsTableView.contentInset.bottom = 72
        
        // create new request
        if let uid = authHandler.firAuth.currentUser?.uid {
            newRequest = Request(senderID: uid, status: nil, delSlotStart: nil, items: [])
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .dark {
            actionBar.layer.shadowOpacity = 0
        } else {
            actionBar.layer.shadowOpacity = 0.5
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return newRequest?.items.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return NewItemCell.buildInstance(for: requestItemsTableView, delegate: self, title: "Add Item") ?? UITableViewCell()
        case 1:
            guard let item = newRequest?.items[indexPath.row] else {
                return UITableViewCell()
            }
            
            if let cell = RequestItemCell.buildInstance(for: requestItemsTableView, delegate: self, title: item.name, icon: item.icon) {
                cell.count = item.qty
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickedCancel(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel new request?", message: "Your current request will be discarded.", preferredStyle: .alert)
        alert.addAction(.init(title: "Don't Cancel", style: .cancel, handler: nil))
        alert.addAction(.init(title: "Confirm", style: .destructive, handler: { (alert) in
            self.cancelNewRequest()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clickedCheckout(_ sender: Any) {
    }
    
    func cancelNewRequest() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func newItem() {
        let catVC = CategoriesViewController(nibName: "CardDetailVC", bundle: nil)
        catVC.delegateCarrier = self
        catVC.itemsCarrier = newRequest?.items
        present(catVC, animated: true, completion: nil)
    }
    
    func plusClicked(for cell: RequestItemCell) {
        updateCountForItemHandler(for: requestItemsTableView, with: self, using: cell, items: newRequest?.items, modifier: 1)
    }
    
    func minusClicked(for cell: RequestItemCell) {
        updateCountForItemHandler(for: requestItemsTableView, with: self, using: cell, items: newRequest?.items, modifier: -1)
    }
    
    func cellTapped(for cell: RequestItemCell) { }
    
    func addItem(item: RequestItem) {
        newRequest?.items.append(item)
        if newRequest?.items.count == 1 {
            actionBar.isHidden = false
        }
        requestItemsTableView.reloadSections(.init(arrayLiteral: 1), with: .fade)
    }
    
    func removeItem(item: RequestItem) {
        newRequest!.items.removeAll { (requestItem) -> Bool in
            requestItem.name == item.name
        }
        if newRequest?.items.count == 0 {
            actionBar.isHidden = true
        }
        requestItemsTableView.reloadSections(.init(arrayLiteral: 1), with: .fade)
    }
    
    func updateItemCount(item: RequestItem, newCount: Int) {
        guard let index = newRequest?.items.firstIndex(where: {$0.name == item.name}) else { return
        }
        let cell = requestItemsTableView.cellForRow(at: .init(row: index, section: 1)) as! RequestItemCell
        cell.count = newCount
        newRequest!.items.first(where: {$0.name == item.name})?.qty = newCount
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol RequestItemHandler {
    func addItem(item: RequestItem)
    func removeItem(item: RequestItem)
    func updateItemCount(item: RequestItem, newCount: Int)
}

func updateCountForItemHandler(for tableView: UITableView, with delegate: RequestItemHandler?, using cell: RequestItemCell, items: [RequestItem]?, modifier: Int) {
    guard let index = tableView.indexPath(for: cell)?.row else {
        return
    }
    
    if let item = items?[index] {
        if modifier > 0 {
            if cell.count == 0 {
                if delegate != nil {
                    delegate?.addItem(item: item)
                }
            }
        } else {
            if cell.count == 1 {
                if delegate != nil {
                    delegate?.removeItem(item: item)
                    item.qty += modifier
                    cell.count += modifier
                    return
                }
            } else if cell.count == 0 {
                return
            }
        }
        item.qty += modifier
        cell.count += modifier
        delegate?.updateItemCount(item: item, newCount: item.qty)
    }
}
