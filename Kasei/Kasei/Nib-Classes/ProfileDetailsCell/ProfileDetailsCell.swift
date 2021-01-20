//
//  ProfileDetailsCell.swift
//  Kasei
//
//  Created by Eugene L. on 20/1/21.
//

import UIKit
class ProfileDetailsCell: ElevatedTableViewCell {
    
    @IBOutlet weak var detailContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        containerView = detailContainer
        
        super.awakeFromNib()
        detailContainer.layer.cornerRadius = 10
    }
    
    static func register(for tableView: UITableView) {
        tableView.register(UINib(nibName: "ProfileDetailsCell", bundle: nil), forCellReuseIdentifier: "profileDetailsCell")
    }
    
    static func buildInstance(for tableView: UITableView) -> ProfileDetailsCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileDetailsCell") as? ProfileDetailsCell else {
            return nil
        }
        
        return cell
    }
}
