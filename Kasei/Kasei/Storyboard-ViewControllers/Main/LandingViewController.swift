//
//  LandingViewController.swift
//  Kasei
//
//  Created by Eugene L. on 14/11/20.
//

import UIKit
import FirebaseDatabase

class LandingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewItemCellProtocol, RequestSummaryCellProtocol {

    @IBOutlet weak var requestTableView: UITableView!
    
    var userRequests = Array<Request>()
    
    let DBRef = Database.database().reference()
    let authHandler = FirAuthHandler.self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        requestTableView.delegate = self
        requestTableView.dataSource = self
        NewItemCell.register(for: requestTableView)
        RequestSummaryCell.register(for: requestTableView)
        
        fetchAllUserRequests { (requests) in
            if requests != nil {
                self.userRequests = requests!
            }
            self.requestTableView.reloadData()
        }
    }
    
    func fetchAllUserRequests(onComplete: @escaping (Array<Request>?) -> ()) {
        // fetch data from firebase
        guard let uid = authHandler.firAuth.currentUser?.uid else {
            print("No UID!")
            return
        }
        
        DBRef.child("userRequests/\(uid)").observe(.value) { (snapshot) in
            var requests = [Request]()
            var counter = snapshot.childrenCount
            for child in snapshot.children {
                let childSnap = child as! DataSnapshot
                let id = childSnap.value as! String
                getRequest(DBRef: self.DBRef, forID: id) { (r) in
                    if r != nil { requests.append(r!) }
                    counter -= 1
                    if counter == 0 {
                        self.userRequests = requests.reversed()
                        self.requestTableView.reloadData()
                    }
                }
            }
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
            return userRequests.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return NewItemCell.buildInstance(for: requestTableView, delegate: self, title: "New Request") ?? UITableViewCell()
        case 1:
            let request = userRequests[indexPath.row]
            if let cell = RequestSummaryCell.buildInstance(for: requestTableView, delegate: self) {
                cell.statusLabel.text = request.status
                cell.deliverySlotLabel.text = request.delSlotString()
                
                // format contents
                var summaryStrings = [String]()
                for item in request.items {
                    summaryStrings.append("\(item.qty) \(item.name)")
                }
                let summary = summaryStrings.joined(separator: ",")
                cell.contentSummary.text = summary
                
                return cell
            } else {
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickedProfileBtn(_ sender: Any) {
        present(ProfileViewController(nibName: "CardDetailVC", bundle: nil), animated: true, completion: nil)
    }
    
    func presentRequestStoryboard() {
        let vc = UIStoryboard(name: "Request", bundle: nil).instantiateInitialViewController()
        guard let loginVC = vc else {
            return
        }
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func presentDetailView(for cell: RequestSummaryCell) {
        if let indexPath = requestTableView.indexPath(for: cell) {
            let detailVC = RequestDetailViewController(nibName: "CardDetailVC", bundle: nil)
            detailVC.request = userRequests[indexPath.row]
            present(detailVC, animated: true, completion: nil)
        } else {
            print("There was an error!")
        }
    }
    
    func newItem() {
        presentRequestStoryboard()
    }
    
    func presentMoreDetails(cell: RequestSummaryCell) {
        presentDetailView(for: cell)
    }
    
    @IBAction func unwindToLandingVC(_ segue: UIStoryboardSegue) {
        self.requestTableView.reloadData()
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
