//
//  NewItemViewViewModel.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import FirebaseStorage

class NewRecipeItemViewViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var instructions: String = ""
    @Published var ingredients: [ProductListItem] = []
    @Published var category: RecipeCategory = .main
    @Published var difficulty: Difficulty = .easy
    @Published var imageURL: String? = nil
    @Published var isPublic: Bool = false
    
    // Дієтичні фільтри
    @Published var isGlutenFree: Bool = false
    @Published var isVegan: Bool = false
    @Published var isVegetarian: Bool = false
    @Published var isDairyFree: Bool = false
    @Published var isNutFree: Bool = false
    @Published var isKidsFree: Bool = false
    
    @Published var showAlert: Bool = false
    
    init() {}
    
    func save(selectedImage: UIImage?) {
        guard canSave else {
            showAlert = true
            return
        }
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let newId = UUID().uuidString
        
        func saveRecipe(imageURL: String?) {
            let newRecipe = RecipeListItem(
                id: newId,
                ownerId: uId,
                title: title,
                ingredients: ingredients,
                instructions: instructions,
                categories: category,
                difficulty: difficulty,
                imageURL: imageURL,
                createdDate: Date().timeIntervalSince1970,
                isFavorite: false,
                isPublic: isPublic,
                isGlutenFree: isGlutenFree,
                isVegan: isVegan,
                isVegetarian: isVegetarian,
                isDairyFree: isDairyFree,
                isNutFree: isNutFree,
                isKidsFree: isKidsFree
            )
            
            let db = Firestore.firestore()
            db.collection("users")
                .document(uId)
                .collection("recipes")
                .document(newId)
                .setData(newRecipe.asDictionary())
        }

        if let image = selectedImage {
            let storageRef = Storage.storage().reference()
                .child("users/\(uId)/recipes/\(newId).jpg")
            
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                storageRef.putData(imageData) { _, error in
                    if error == nil {
                        storageRef.downloadURL { url, _ in
                            saveRecipe(imageURL: url?.absoluteString)
                        }
                    } else {
                        saveRecipe(imageURL: nil)
                    }
                }
            } else {
                saveRecipe(imageURL: nil)
            }
        } else {
            saveRecipe(imageURL: nil)
        }
    }


        var canSave: Bool {
            guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
            guard !instructions.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
            guard !ingredients.isEmpty else { return false }
            return true
        }
}
