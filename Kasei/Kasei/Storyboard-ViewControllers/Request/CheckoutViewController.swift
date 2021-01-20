//
//  CheckoutViewController.swift
//  Kasei
//
//  Created by Eugene L. on 19/11/20.
//

import UIKit
import FirebaseDatabase

class CheckoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonCellProtocol {
    
    @IBOutlet weak var actionBar: UIView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var checkoutTableView: UITableView!
    
    @IBOutlet weak var resultCardContainer: UIView!
    @IBOutlet weak var resultCardIcon: UIImageView!
    @IBOutlet weak var resultCardText: UILabel!
    @IBOutlet weak var resultLoadIndicator: UIActivityIndicatorView!
    
    var request: Request?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        checkoutTableView.delegate = self
        checkoutTableView.dataSource = self
        CheckoutDetailCell.register(for: checkoutTableView)
        HeaderCell.register(for: checkoutTableView)
        RequestItemCell.register(for: checkoutTableView)
        
        // make action bar cooler
        actionBar.setShadow(col: UIColor.lightGray.cgColor, opacity: 0.5, offset: .zero, rad: 4)
        traitCollectionDidChange(nil)
        
        // add bottom inset for button
        checkoutTableView.contentInset.bottom = 72
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.userInterfaceStyle == .dark {
            actionBar.layer.shadowOpacity = 0
        } else {
            actionBar.layer.shadowOpacity = 0.5
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1,2:
            return 1
        case 3:
            return request?.items.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return HeaderCell.buildInstance(for: checkoutTableView, header: NSLocalizedString("Select a time for delivery: ", comment: "")) ?? UITableViewCell()
        case 1:
            return CheckoutDetailCell.buildInstance(for: checkoutTableView) ?? UITableViewCell()
        case 2:
            return HeaderCell.buildInstance(for: checkoutTableView, header: NSLocalizedString("Review your items: ", comment: "")) ?? UITableViewCell()
        case 3:
            let item = request!.items[indexPath.row]
            if let cell = RequestItemCell.buildInstance(for: checkoutTableView, delegate: nil, title: item.name, icon: item.icon) {
                cell.count = item.qty
                cell.disableModifierBtns()
                return cell
            }
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func dimissClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedSend(_ sender: Any) {
        self.isModalInPresentation = true
        guard let detailCell = checkoutTableView.cellForRow(at: .init(row: 0, section: 1)) as? CheckoutDetailCell else {
            return
        }
        
        request?.delSlotStart = detailCell.getStartDelSlot()
        request?.status = "sent"
        
        let DBRef = Database.database().reference()
        
        showResultCard()
        if let req = request {
            postRequest(DBRef: DBRef, req: req) { (success) in
                self.resultLoadIndicator.stopAnimating()
                self.resultCardIcon.isHidden = false
                if success == true {
                    self.resultDisplaySuccess()
                } else {
                    self.resultDisplayFailure()
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    self.returnToMain()
                }
            }
        }
    }
    
    func showResultCard() {
        resultCardContainer.isHidden = false
        resultLoadIndicator.startAnimating()
        resultCardText.text = NSLocalizedString("Sending...", comment: "")
    }
    
    func resultDisplaySuccess() {
        resultCardIcon.image = UIImage(systemName: "checkmark.circle.fill")
        resultCardIcon.tintColor = UIColor(named: "Accent Static")
        resultCardText.text = NSLocalizedString("Success!", comment: "")
    }
    
    func resultDisplayFailure() {
        resultCardIcon.image = UIImage(systemName: "xmark.circle.fill")
        resultCardIcon.tintColor = UIColor(named: "Destructive")
        resultCardText.text = NSLocalizedString("Something went wrong!", comment: "")
    }
    
    func returnToMain() {
        performSegue(withIdentifier: "unwindToLanding", sender: self)
    }
    
    func buttonClicked(reuseId: String) {
        switch reuseId {
        case "confirmButtonCell":
            return
        default:
            return
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
