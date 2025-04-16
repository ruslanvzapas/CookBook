//
//  ProductListViewViewModel.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import FirebaseFirestore
import Foundation

class RecipeListViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
        
        private let userId: String
        
        init(userId: String) {
            self.userId = userId
        }
        
        /// Видалення рецепта
        /// - Parameter id: ID рецепта, який потрібно видалити
        func delete(id: String) {
            let db = Firestore.firestore()
            db.collection("users")
                .document(userId)
                .collection("recipes")
                .document(id)
                .delete()
        }
}
