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
            if snapshot.exists() {
                var requests = Array<Request>()
                for child in snapshot.children {
                    let childSnapshot = child as! DataSnapshot
                    self.fetchRequest(for: childSnapshot.value as! String) { (request) in
                        requests.append(request)
                    }
                }
                onComplete(requests)
            }
        }
    }
    
    func fetchRequest(for id: String, onComplete: (Request) -> ()) {
        DBRef.child("requests/\(id)").observe(.value) { (snapshot) in
            if snapshot.exists() {
                // decode to request
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
            return RequestSummaryCell.buildInstance(for: requestTableView, delegate: self) ?? UITableViewCell()
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
        let indexPath = requestTableView.indexPath(for: cell)
        let detailVC = RequestDetailViewController(nibName: "CardDetailVC", bundle: nil)
        //TODO: Make a model, get data, pass data into detail vc, etc...
        present(detailVC, animated: true, completion: nil)
    }
    
    func newItem() {
        presentRequestStoryboard()
    }
    
    func presentMoreDetails(cell: RequestSummaryCell) {
        presentDetailView(for: cell)
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
