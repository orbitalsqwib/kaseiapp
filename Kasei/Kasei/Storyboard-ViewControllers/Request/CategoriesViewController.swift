//
//  CategoriesViewController.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit
import FirebaseDatabase

class CategoriesViewController: CardDetailVC, UITableViewDelegate, UITableViewDataSource, RequestItemCellProtocol {
    
    var delegateCarrier: RequestItemHandler?
    var itemsCarrier: [RequestItem]?
    var categories: [ItemCategory]?
    
    let DBRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardTitle.text = "Categories"
        
        cardTableView.delegate = self
        cardTableView.dataSource = self
        RequestItemCell.register(for: cardTableView)
        
        getItemCategories(DBRef: DBRef, onComplete: { (categories) in
            self.categories = categories
            self.cardTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories![indexPath.row]
        if let cell = RequestItemCell.buildInstance(for: cardTableView, delegate: self, title: category.category, icon: category.icon) {
            cell.disableCounter()
            cell.enableTapper()
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func plusClicked(for cell: RequestItemCell) { }
    func minusClicked(for cell: RequestItemCell) { }
    func cellTapped(for cell: RequestItemCell) {
        if let indexPath = cardTableView.indexPath(for: cell) {
            let category = categories![indexPath.row]
            let itemsVC = ItemsViewController(nibName: "CardDetailVC", bundle: nil)
            itemsVC.titleText = category.category
            itemsVC.itemIDs = category.itemIDs
            itemsVC.delegate = delegateCarrier
            itemsVC.basketItems = itemsCarrier ?? []
            present(itemsVC, animated: true, completion: nil)
        }
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
