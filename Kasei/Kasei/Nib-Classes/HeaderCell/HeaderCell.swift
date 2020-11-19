//
//  HeaderCell.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerContainer.layer.cornerRadius = 10
    }
    
    static func register(withReuseId id: String, for tableView: UITableView) {
        tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: id)
    }
    
    static func buildInstance(withReuseId id: String, for tableView: UITableView, header: String) -> HeaderCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id) as? HeaderCell else {
            return nil
        }
        
        cell.headerLabel.text = header
        return cell
    }

}
