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
        // search items for matching id
        var match = false
        for i in items {
            if i.id == item.id {
                match = true
                i.qty += modifier
                if i.qty <= 0 { removeItem(with: i.id) }
            }
        }
        
        if !match {
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
