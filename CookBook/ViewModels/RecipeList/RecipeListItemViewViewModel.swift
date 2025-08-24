//
//  ProductListItemViewViewModel.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class RecipeListItemViewViewModel: ObservableObject {
    init() {}
    
    func toggleIsFavorite(for recipe: RecipeListItem) {
        var updatedRecipe = recipe
        updatedRecipe.setFavorite(!recipe.isFavorite)
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(uid)
            .collection("recipes")
            .document(updatedRecipe.id)
            .setData(updatedRecipe.asDictionary())
    }
}
