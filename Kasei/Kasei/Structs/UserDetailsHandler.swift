//
//  UserDetailsHandler.swift
//  Kasei
//
//  Created by Eugene L. on 20/1/21.
//

import Foundation
import FirebaseDatabase

struct UserDetailsHandler {
    
    static func retrieveSubzone(DBRef: DatabaseReference, onComplete: @escaping (_ subzone: String, _ success: Bool) -> ()) {
        
        guard let uid = FirAuthHandler.firAuth.currentUser?.uid else {
            onComplete("", false)
            return
        }
        
        DBRef.child("elderly/\(uid)").child("ZoneID").observeSingleEvent(of: .value) { (snapshot) in
            
            if let zoneid = snapshot.value as? String {
                onComplete(zoneid, true)
            } else {
                onComplete("", false)
            }
        }
    }
}
