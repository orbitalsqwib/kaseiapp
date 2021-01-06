//
//  RequestItem.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import Foundation
import FirebaseDatabase

class RequestItem: Codable {
    var id: String
    var name: String
    var icon: String
    var qty: Int
    var bgCol: String
    
    init(id: String, name: String, icon: String, qty: Int, bgCol: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.qty = qty
        self.bgCol = bgCol
    }
}

func getRequestItem(DBRef: DatabaseReference, forID id: String, onComplete: @escaping (RequestItem?) -> ()) {
    DBRef.child("items/\(id)").observeSingleEvent(of: .value) { (snapshot) in
        
        var path = "name"
        
        if Locale.current.languageCode == "zh" {
            path += "_zh"
        }
        
        guard let name = snapshot.childSnapshot(forPath: path).value as? String else {
            onComplete(nil)
            return
        }
        
        guard let icon = snapshot.childSnapshot(forPath: "icon").value as? String else {
            onComplete(nil)
            return
        }
        
        guard let bgCol = snapshot.childSnapshot(forPath: "bgCol").value as? String else {
            onComplete(nil)
            return
        }
        
        onComplete(RequestItem(id: id, name: name, icon: icon, qty: 0, bgCol: bgCol))
    }
}
