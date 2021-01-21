//
//  CDHandler.swift
//  Kasei
//
//  Created by Eugene L. on 5/1/21.
//

import UIKit
import CoreData

struct CDHandler {
    
    static func saveRequest(request: Request) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var entity = NSEntityDescription.entity(forEntityName: "CDRequest", in: context)!
        
        // create request
        let cdrequest = CDRequest(entity: entity, insertInto: context)
        cdrequest.setValue(request.id, forKey: "id")
        cdrequest.setValue(request.dateCreated, forKey: "dateCreated")
        cdrequest.setValue(request.senderID, forKey: "senderID")
        cdrequest.setValue(request.status, forKey: "status")
        cdrequest.setValue(request.delSlotStart, forKey: "delSlotStart")
        cdrequest.setValue(true, forKey: "isNew")
        
        // add items to request
        entity = NSEntityDescription.entity(forEntityName: "CDRequestItem", in: context)!
        
        for item in request.items {
            let cditem = CDRequestItem(entity: entity, insertInto: context)
            cditem.setValue(item.id, forKey: "id")
            cditem.setValue(item.name, forKey: "name")
            cditem.setValue(item.icon, forKey: "icon")
            cditem.setValue(item.qty, forKey: "qty")
            cditem.setValue(item.bgCol, forKey: "bgCol")
            cditem.setValue(item.qtyLimit, forKey: "qtyLimit")
            cditem.setValue(item.qtyRemaining, forKey: "qtyRemaining")
            
            cdrequest.addToItems(cditem)
        }
        
        // save changes made
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error) \(error.userInfo)")
        }
    }
    
    static func deleteRequest(id: String) {
        var cdrequests = [CDRequest]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<CDRequest>(entityName: "CDRequest")
        request.predicate = NSPredicate(format: "id == %s", argumentArray: [id])
        
        do {
            cdrequests = try context.fetch(request)
            if cdrequests.first != nil {
                context.delete(cdrequests.first!)
            }
            
            try context.save()
        } catch let error as NSError {
            print("Could not delete. \(error) \(error.userInfo)")
        }
    }
    
    static func loadAllRequests() -> [Request] {
        var requests = [Request]()
        var cdrequests = [CDRequest]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
        let sortDescriptors = [sortDescriptor]
        let request = NSFetchRequest<CDRequest>(entityName: "CDRequest")
        request.sortDescriptors = sortDescriptors
        
        do {
            cdrequests = try context.fetch(request)
        }  catch let error as NSError {
            print("Could not fetch. \(error) \(error.userInfo)")
            return requests
        }
        
        // if fetch is successful, convert cd class into regular class
        for cdr in cdrequests {
            var req = Request(id: cdr.id, dateCreated: cdr.dateCreated, senderID: cdr.senderID!, status: cdr.status, delSlotStart: cdr.delSlotStart, items: [])
            req.isNew = cdr.isNew
            
            var cditems = cdr.items?.allObjects as! [CDRequestItem]
            cditems.sort{$0.name! < $1.name!}
            
            for cdi in cditems {
                let itm = RequestItem(id: cdi.id!, name: cdi.name!, icon: cdi.icon!, qty: Int(cdi.qty), bgCol: cdi.bgCol!)
                req.items.append(itm)
            }
            
            requests.append(req)
        }
        
        return requests
    }
    
    static func markRequestAsOld(id: String) {
        var cdrequests = [CDRequest]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<CDRequest>(entityName: "CDRequest")
        request.predicate = NSPredicate(format: "id == %s", argumentArray: [id])
        
        do {
            cdrequests = try context.fetch(request)
            if cdrequests.first != nil {
                cdrequests.first!.setValue(false, forKey: "isNew")
            }
            
            try context.save()
        } catch let error as NSError {
            print("Could not update. \(error) \(error.userInfo)")
        }
    }
    
    static func updateSavedRequests(newRequests: [Request]) {
        var oldRequests = loadAllRequests()
        var newRequests = newRequests
        
        let defaults = UserDefaults.standard
        let changedLocale = defaults.string(forKey: "currLocale") != Locale.current.languageCode
        
        // leave matching requests alone
        while oldRequests.count > 0 {
            
            var hasMatch = false
            
            for i in 0..<newRequests.count {
                if changedLocale { break }
                else if oldRequests.first!.id == newRequests[i].id && oldRequests.first!.status == newRequests[i].status {
                    
                    if oldRequests.first!.isNew ?? false {
                        markRequestAsOld(id: oldRequests.first!.id!)
                    }
                    newRequests.remove(at: i)
                    oldRequests.removeFirst()
                    hasMatch = true
                    break
                    
                }
            }
            
            // delete old requests
            if !hasMatch {
                deleteRequest(id: oldRequests.first!.id!)
                oldRequests.removeFirst()
            }
        }
        
        // save new requests
        for request in newRequests {
            saveRequest(request: request)
        }
        
        // update defaults to new locale (if changed)
        if changedLocale {
            defaults.setValue(Locale.current.languageCode, forKey: "currLocale")
        }
    }
    
}
