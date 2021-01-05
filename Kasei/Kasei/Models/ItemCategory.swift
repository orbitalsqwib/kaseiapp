//
//  ItemCategories.swift
//  Kasei
//
//  Created by Eugene L. on 19/11/20.
//

import Foundation
import FirebaseDatabase

struct ItemCategory: Codable {
    var category: String
    var icon: String
    var itemIDs: [String]
}

func getItemCategories(DBRef: DatabaseReference, onComplete: @escaping ([ItemCategory]?) -> ()) {
    DBRef.child("categories").observeSingleEvent(of: .value) { (snapshot) in
        
        guard snapshot.exists() else {
            return
        }
        
        var categories = [ItemCategory]()
        
        for categoryChild in snapshot.children {
            let categorySnap = categoryChild as! DataSnapshot
            
            var path = "category"
            
            switch Locale.current.languageCode {
            case "zh":
                path += "_zh"
                break;
            default:
                break;
            }
            
            guard let category = categorySnap.childSnapshot(forPath: path).value as? String else {
                continue
            }
            
            guard let icon = categorySnap.childSnapshot(forPath: "icon").value as? String else {
                continue
            }
            
            var itemids = [String]()
            let itemSnap = categorySnap.childSnapshot(forPath: "items")
            for child in itemSnap.children {
                let childSnap = child as! DataSnapshot
                let id = childSnap.value as! String
                itemids.append(id)
            }
            
            categories.append(ItemCategory(category: category, icon: icon, itemIDs: itemids))
        }
        
        onComplete(categories)
    }
}
