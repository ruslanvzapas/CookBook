//
//  ProductListItem.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import Foundation

struct ProductListItem: Codable, Identifiable {
    let id: String
    var title: String
    var quantity: String
    // let dueDate: TimeInterval
    // let createdDate: TimeInterval
    var isDone: Bool
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}
