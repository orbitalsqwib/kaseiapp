//
//  UserDetailsHandler.swift
//  Kasei
//
//  Created by Eugene L. on 20/1/21.
//

import Foundation
import FirebaseDatabase

struct ProfileDetails {
    var name: String
    var email: String
    var address: String
}

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
    
    static func retrieveProfileDetails(onComplete: @escaping (ProfileDetails?) -> ()) {
        
        let DBRef = Database.database().reference()
        
        guard let uid = FirAuthHandler.firAuth.currentUser?.uid else {
            onComplete(nil)
            return
        }
        
        DBRef.child("elderly/\(uid)").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let name = snapshot.childSnapshot(forPath: "Name").value as? String else {
                onComplete(nil)
                return
            }
            
            guard let email = snapshot.childSnapshot(forPath: "Email").value as? String else {
                onComplete(nil)
                return
            }
            
            guard let address = snapshot.childSnapshot(forPath: "Address").value as? String else {
                onComplete(nil)
                return
            }
            
            guard let postalCode = snapshot.childSnapshot(forPath: "PostalCode").value as? String else {
                onComplete(nil)
                return
            }
            
            let addressString = "\(address), \(NSLocalizedString("Singapore", comment: "")) \(postalCode)"
            
            onComplete(ProfileDetails(name: name, email: email, address: addressString))
        }
    }
}
