//
//  NewItemCell.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit

class NewItemCell: UITableViewCell {

    @IBOutlet weak var newItmButton: UIButton!
    
    var delegate: NewItemCellProtocol? = nil
    
    var title: String = "" {
        didSet {
           newItmButton.setTitle("＋ " + title, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        newItmButton.layer.cornerRadius = 10
        newItmButton.layer.borderWidth = 4
        newItmButton.layer.borderColor = UIColor(named: "Button Text Inverse")?.cgColor
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        newItmButton.layer.borderColor = UIColor(named: "Button Text Inverse")?.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
    
    @IBAction func newItemClicked(_ sender: Any) {
        if delegate != nil {
            delegate!.newItem()
        }
    }
    
    static func register(for tableView: UITableView) {
        tableView.register(UINib(nibName: "NewItemCell", bundle: nil), forCellReuseIdentifier: "newItemCell")
    }
    
    static func buildInstance(for tableView: UITableView, delegate: NewItemCellProtocol?, title: String) -> NewItemCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newItemCell") as? NewItemCell else {
            return nil
        }
        
        cell.delegate = delegate
        cell.title = title
        return cell
    }
    
}

protocol NewItemCellProtocol {
    func newItem()
}
