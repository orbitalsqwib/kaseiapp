//
//  RequestSummaryCellTableViewCell.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit

class RequestSummaryCell: ElevatedTableViewCell {

    @IBOutlet weak var summaryContainer: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var deliverySlotLabel: UILabel!
    @IBOutlet weak var contentSummary: UILabel!
    
    var delegate: RequestSummaryCellProtocol? = nil
    
    override func awakeFromNib() {
        //Pre-initialization code
        containerView = summaryContainer
        
        super.awakeFromNib()
        containerView?.layer.cornerRadius = 10
    }

    @IBAction func moreDetailsClicked(_ sender: Any) {
        if delegate != nil {
            delegate!.presentMoreDetails(cell: self)
        }
    }
    
    static func register(for tableView: UITableView) {
        tableView.register(UINib(nibName: "RequestSummaryCell", bundle: nil), forCellReuseIdentifier: "requestSummaryCell")
    }
    
    static func buildInstance(for tableView: UITableView, delegate: RequestSummaryCellProtocol?) -> RequestSummaryCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "requestSummaryCell") as? RequestSummaryCell else {
            return nil
        }
        
        cell.delegate = delegate
        return cell
    }
    
}

protocol RequestSummaryCellProtocol {
    func presentMoreDetails(cell: RequestSummaryCell)
}
