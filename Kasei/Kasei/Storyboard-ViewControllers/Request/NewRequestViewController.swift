//
//  NewRequestViewController.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit

class NewRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewItemCellProtocol, RequestItemCellProtocol {

    @IBOutlet weak var requestItemsTableView: UITableView!
    
    var newRequest: Request?
    
    let authHandler = FirAuthHandler.self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        requestItemsTableView.delegate = self
        requestItemsTableView.dataSource = self
        NewItemCell.register(for: requestItemsTableView)
        RequestItemCell.register(for: requestItemsTableView)
        
        // create new request
        if let uid = authHandler.firAuth.currentUser?.uid {
            newRequest = Request(senderID: uid, status: nil, delSlotStart: nil, items: [])
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
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return NewItemCell.buildInstance(for: requestItemsTableView, delegate: self, title: "Add Item") ?? UITableViewCell()
        case 1:
            if let cell = RequestItemCell.buildInstance(for: requestItemsTableView, delegate: self, title: "Test", icon: "") {
                cell.disableModifierBtns()
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
    
    func cancelNewRequest() {
        self.navigationController?.dismiss(animated: true, completion: {
            //code
        })
    }
    
    func newItem() {
        present(CategoriesViewController(nibName: "CardDetailVC", bundle: nil), animated: true, completion: nil)
    }
    
    func plusClicked(for cell: RequestItemCell) {
        //code
    }
    
    func minusClicked(for cell: RequestItemCell) {
        //code
    }
    
    func cellTapped(for cell: RequestItemCell) {
        //code
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
    func updateItemCount(index: Int)
}
