//
//  Request.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import Foundation
import FirebaseDatabase

struct Request: Codable {
    var senderID: String
    var status: String?
    var delSlotStart: Date?
    var items: Array<RequestItem>
    
    func delSlotString() -> String? {
        // format date
        if let slotStart = delSlotStart {
            let slotEnd = slotStart.addingTimeInterval(.init(60*60*2)) // +2h
            let startFormatter = DateFormatter()
            startFormatter.dateFormat = "dd MMM yyyy, ha"
            let endFormatter = DateFormatter()
            endFormatter.dateFormat = "ha"
            
            return startFormatter.string(from: slotStart) + " - " + endFormatter.string(from: slotEnd)
        }
        return nil
    }
}

func getRequest(DBRef: DatabaseReference, forID id: String, onComplete: @escaping (Request?) -> ()) {
    DBRef.child("requests/\(id)").observeSingleEvent(of: .value) { (snapshot) in
        guard let senderID = snapshot.childSnapshot(forPath: "senderID").value as? String else {
            onComplete(nil)
            return
        }
        
        guard let status = snapshot.childSnapshot(forPath: "status").value as? String else {
            onComplete(nil)
            return
        }
        
        guard let delSlotStart = snapshot.childSnapshot(forPath: "delSlotStart").value as? Int else {
            onComplete(nil)
            return
        }
        
        let delSlotStartDate = Date(timeIntervalSince1970: TimeInterval(delSlotStart) / 1000 )
        
        let contentSnap = snapshot.childSnapshot(forPath: "content")
        getAllItems(DBRef: DBRef, forContentSnapshot: contentSnap) { (items) in
            onComplete(Request(senderID: senderID, status: status, delSlotStart: delSlotStartDate, items: items))
        }
    }
}

func getAllItems(DBRef: DatabaseReference, forContentSnapshot snap: DataSnapshot, onComplete: @escaping ([RequestItem]) -> ()) {
    var items = [RequestItem]()
    var counter = snap.childrenCount
    for child in snap.children {
        let childSnap = child as! DataSnapshot
        let itemID = childSnap.key
        getRequestItem(DBRef: DBRef, forID: itemID) { (item) in
            if let i = item {
                i.qty = childSnap.value as! Int
                items.append(i)
            }
            
            counter -= 1
            if counter == 0 {
                onComplete(items)
            }
        }
    }
}
