//
//  Ingredient.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 06.04.2025.
//

struct Ingredient: Identifiable, Codable {
    let id: String
    var name: String
    var quantity: String
    var isChecked: Bool 
    
    mutating func setChecked(_ state: Bool) {
        isChecked = state
    }
}
