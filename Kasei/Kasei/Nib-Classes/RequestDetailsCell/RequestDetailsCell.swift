//
//  RequestDetailsCell.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit

class RequestDetailsCell: ElevatedTableViewCell {

    @IBOutlet weak var detailContainer: UIView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var deliverySlotLabel: UILabel!
    
    override func awakeFromNib() {
        //Pre-initialisation code
        containerView = detailContainer
        
        super.awakeFromNib()
        detailContainer.layer.cornerRadius = 10
    }
    
    static func register(for tableView: UITableView) {
        tableView.register(UINib(nibName: "RequestDetailsCell", bundle: nil), forCellReuseIdentifier: "requestDetailsCell")
    }
    
    static func buildInstance(for tableView: UITableView) -> RequestDetailsCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "requestDetailsCell") as? RequestDetailsCell else {
            return nil
        }
        
        return cell
    }


}
