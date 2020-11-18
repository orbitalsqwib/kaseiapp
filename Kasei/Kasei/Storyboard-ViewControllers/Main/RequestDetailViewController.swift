//
//  RequestDetailViewController.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit

class RequestDetailViewController: CardDetailVC, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardTitle.text = "Details"
        
        cardTableView.delegate = self
        cardTableView.dataSource = self
        RequestDetailsCell.register(for: cardTableView)
        HeaderCell.register(withReuseId: "contentHeaderCell", for: cardTableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 3:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = RequestDetailsCell.buildInstance(for: cardTableView) {
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            return HeaderCell.buildInstance(withReuseId: "contentHeaderCell", for: cardTableView, header: "Content") ?? UITableViewCell()
        default:
            return UITableViewCell()
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
