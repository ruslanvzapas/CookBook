//
//  RecipeListItem.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 05.04.2025.
//

import Foundation

struct RecipeListItem: Codable, Identifiable {
    let id: String
    var ownerId: String? 
    var title: String
    var ingredients: [ProductListItem]
    var instructions: String
    var categories: RecipeCategory
    var difficulty: Difficulty
    var imageURL: String?
    let createdDate: TimeInterval
    var isFavorite: Bool
    var isPublic: Bool
    var publicURL: URL? {
        guard isPublic else { return nil }
        return URL(string: "cookbook://recipe?id=\(id)")
    }
    //Dietary filters
    var isGlutenFree: Bool = false
    var isVegan: Bool = false
    var isVegetarian: Bool = false
    var isDairyFree: Bool = false
    var isNutFree: Bool = false
    var isKidsFree: Bool = false
    
    mutating func setFavorite(_ state: Bool) {
        isFavorite = state
    }
}

enum Difficulty: String, CaseIterable, Identifiable, Codable {
    var id: String { self.rawValue }
    
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

enum RecipeCategory: String, CaseIterable, Identifiable, Codable {
    var id: String { self.rawValue }
    
    case breakfast = "Breakfast"
    case soup = "Soup"
    case salad = "Salad"
    case appetizer = "Appetizer"
    case main = "Main Course"
    case side = "Side Dish"
    case dessert = "Dessert"
    case snack = "Snack"
    case drink = "Drink"
    case baking = "Baking"
    case pasta = "Pasta"
    case pizza = "Pizza"
    case seafood = "Seafood"
    case quickAndEasy = "Quick & Easy"
}
