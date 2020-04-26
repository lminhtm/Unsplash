//
//  APICollection.swift
//  Unsplash
//
//  Created by LMinh on 4/25/20.
//  Copyright © 2020 LMinh. All rights reserved.
//

import Foundation
import ObjectMapper

struct APICollection<Element: Mappable & Equatable> {
    
    var items: [Element] = []
    var totalCount: Int = 0
    
    /// Subscript
    subscript(_ index: Int) -> Element? {
        get {
            guard index < items.count else { return nil }
            return items[index]
        }
        set {
            guard let newValue = newValue else { return }
            items[index] = newValue
        }
    }
    
    /// A Boolean value indicating whether the collection is empty.
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    /// Check if the collection has more items or not
    func hasMoreItems() -> Bool {
        return !isEmpty && (items.count < totalCount)
    }
    
    /// Update items with other collection
    mutating func update(with other: APICollection?) {
        guard let other = other else { return }
        
        // Insert new items to the collection
        var itemsCount = 0
        for item in other.items {
            if !items.contains(item) {
                items.append(item)
                itemsCount += 1
            }
            else if let index = items.firstIndex(of: item) {
                items[index] = item
            }
        }
        
        // Total count
        totalCount = other.totalCount
    }
    
    /// Update items with other collection
    mutating func updateItems(with otherItems: [Element]?) {
        guard let otherItems = otherItems else { return }
        
        items = otherItems
        totalCount = otherItems.count
    }
    
    /// Remove all elements and reset states of object
    mutating func clear() {
        totalCount = 0
        items.removeAll()
    }
}

// MARK: - Mappable

extension APICollection: Mappable {
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        items <- map["results"]
        totalCount <- map["total"]
    }
}
