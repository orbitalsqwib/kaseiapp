//
//  RequestItemCell.swift
//  Kasei
//
//  Created by Eugene L. on 14/11/20.
//

import UIKit

class RequestItemCell: ElevatedTableViewCell {
    
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var counterContainer: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var minusContainer: UIView!
    @IBOutlet weak var plusContainer: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tapper: UIButton!
    
    var delegate: RequestItemCellProtocol? = nil
    
    var title: String = "Title" {
        didSet { mainTitle.text = title }
    }
    var icon: String = "" {
        didSet { iconLabel.text = icon }
    }
    var count: Int = 0 {
        didSet {
            countLabel.text = String(count)
        }
    }

    override func awakeFromNib() {
        // Pre-initialisation code
        containerView = cellContainer
        
        super.awakeFromNib()
        cellContainer.layer.cornerRadius = 10
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
    
    @IBAction func plusBtnClicked(_ sender: Any) {
        if delegate != nil {
            delegate!.plusClicked(for: self)
        }
    }
    
    @IBAction func minusBtnClicked(_ sender: Any) {
        if delegate != nil {
            delegate!.minusClicked(for: self)
        }
    }
    
    @IBAction func cellTapped(_ sender: Any) {
        if delegate != nil {
            delegate!.cellTapped(for: self)
        }
    }
    
    func disableModifierBtns() {
        if minusContainer != nil && plusContainer != nil {
            minusContainer.removeFromSuperview()
            plusContainer.removeFromSuperview()
        }
    }
    
    func disableCounter() {
        counterContainer.removeFromSuperview()
    }
    
    func enableTapper() {
        tapper.isEnabled = true
    }
    
    static func register(for tableView: UITableView) {
        tableView.register(UINib(nibName: "RequestItemCell", bundle: nil), forCellReuseIdentifier: "requestItemCell")
    }
    
    static func buildInstance(for tableView: UITableView, delegate: RequestItemCellProtocol?, title: String, icon: String) -> RequestItemCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "requestItemCell") as? RequestItemCell else {
            return nil
        }
        
        cell.delegate = delegate
        cell.title = title
        cell.icon = icon
        return cell
    }
    
}

protocol RequestItemCellProtocol {
    func minusClicked(for cell: RequestItemCell)
    func plusClicked(for cell: RequestItemCell)
    func cellTapped(for cell: RequestItemCell)
}
