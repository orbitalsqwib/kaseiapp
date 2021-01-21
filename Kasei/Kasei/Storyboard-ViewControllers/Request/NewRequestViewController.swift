//
//  NewRequestViewController.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit

class NewRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewItemCellProtocol, RequestItemCellProtocol, RequestItemViewProtocol {

    @IBOutlet weak var requestItemsTableView: UITableView!
    @IBOutlet weak var actionBar: UIView!
    @IBOutlet weak var checkoutBtn: UIButton!
    
    var newRequest: Request?
    
    var basket = Basket()
    
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
            newRequest = Request(id: nil, dateCreated: nil, senderID: uid, status: nil, delSlotStart: nil, items: [])
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
            return basket.items.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return NewItemCell.buildInstance(for: requestItemsTableView, delegate: self, title: NSLocalizedString("Add Item", comment: "")) ?? UITableViewCell()
        case 1:
            let item = basket.items[indexPath.row]
            
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
        let alert = UIAlertController(title: NSLocalizedString("Cancel new request?", comment: ""), message: NSLocalizedString("Your current request will be discarded.", comment: ""), preferredStyle: .alert)
        alert.addAction(.init(title: NSLocalizedString("Don't Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(.init(title: NSLocalizedString("Confirm", comment: ""), style: .destructive, handler: { (alert) in
            self.cancelNewRequest()
        }))
        alert.view.tintColor = UIColor(named: "Tint")
        self.present(alert, animated: true, completion: nil)
    }
    
    func cancelNewRequest() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func newItem() {
        let catVC = CategoriesViewController(nibName: "CardDetailVC", bundle: nil)
        catVC.itemViewDelegate = self
        catVC.basketDelegate = basket
        present(catVC, animated: true, completion: nil)
    }
    
    func plusClicked(for cell: RequestItemCell) {
        guard let item = getItem(for: cell, in: requestItemsTableView, with: basket.items) else {
            return
        }
        
        basket.update(item: item, modifier: 1, updateItems: { (updatedItems) in
            self.updateView(with: updatedItems)
        })
    }
    
    func minusClicked(for cell: RequestItemCell) {
        guard let item = getItem(for: cell, in: requestItemsTableView, with: basket.items) else {
            return
        }
        
        basket.update(item: item, modifier: -1, updateItems: { (updatedItems) in
            self.updateView(with: updatedItems)
        })
    }
    
    func cellTapped(for cell: RequestItemCell) { }
    
    func updateView(with items: [RequestItem]) {
        basket.items = items
        
        // activate action bar only if basket contains items
        actionBar.isHidden = basket.items.count <= 0
        
        requestItemsTableView.reloadSections(.init(arrayLiteral: 1), with: .fade)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CheckoutViewController {
            let destVC = segue.destination as? CheckoutViewController
            newRequest?.items = basket.items
            destVC?.request = newRequest
        }
    }


}

func getItem(for cell: RequestItemCell, in tableView: UITableView, with itemDataSource: [RequestItem]) -> RequestItem? {
    guard let index = tableView.indexPath(for: cell)?.row else {
        return nil
    }
    
    return itemDataSource[index]
    
}

protocol RequestItemViewProtocol : class {
    func updateView(with items: [RequestItem])
}
