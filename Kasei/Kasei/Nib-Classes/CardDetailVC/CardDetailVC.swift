//
//  CardDetailVC.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit

class CardDetailVC: UIViewController {

    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var cardTableView: UITableView!

    @IBAction func clickedDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
