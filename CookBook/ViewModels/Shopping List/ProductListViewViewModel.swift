//
//  ProductListViewViewModel.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import FirebaseFirestore
import Foundation

class ProductListViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func addIngredientsFromRecipe(_ ingredients: [ProductListItem]) {
        let db = Firestore.firestore()
        let batch = db.batch()

        for ingredient in ingredients {
            let newDocRef = db.collection("users").document(userId).collection("products").document()
            let data: [String: Any] = [
                "id": newDocRef.documentID,
                "title": ingredient.title,
                "quantity": ingredient.quantity,
                "isDone": false
            ]
            batch.setData(data, forDocument: newDocRef)
        }

        batch.commit { error in
            if let error = error {
                print("Помилка при додаванні інгредієнтів: \(error.localizedDescription)")
            } else {
                print("Інгредієнти успішно додані до кошика")
            }
        }
    }
    
    /// Delete product list item
    /// - Parameter id: Item id to delete
    func delete(id: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("products")
            .document(id)
            .delete()
    }
}
