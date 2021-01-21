//
//  Basket.swift
//  Kasei
//
//  Created by Eugene L. on 21/1/21.
//

import Foundation

class Basket: BasketHandlerProtocol {
    var items = [RequestItem]()
    
    private func removeItem(with id: String) {
        items.removeAll { (item) -> Bool in
            return item.id == id
        }
    }
    
    func update(item: RequestItem, modifier: Int, updateItems: (([RequestItem]) -> Void)?) {
        
        // item must have limit
        guard item.qtyLimit != nil else {
            return
        }
        
        // search items for matching id
        var match = false
        for i in items {
            if i.id == item.id {
                match = true
                i.qty = min(i.qty + modifier, i.qtyLimit!)
                if i.qty <= 0 { removeItem(with: i.id) }
            }
        }
        
        if !match && modifier > 0 {
            item.qty += 1
            items.append(item)
        }
        
        if let ret = updateItems {
            ret(items)
        }
    }
    
    func retrieveItems() -> [RequestItem] {
        return items
    }
}

protocol BasketHandlerProtocol : class {
    func retrieveItems() -> [RequestItem]
    func update(item: RequestItem, modifier: Int, updateItems: (([RequestItem]) -> Void)?)
}
