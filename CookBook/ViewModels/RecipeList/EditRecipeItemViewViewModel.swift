//
//  EditRecipeItemViewViewModel.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 15.05.2025.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class EditRecipeItemViewViewModel: ObservableObject {
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
    var recipeId: String? // ID рецепту, який редагується
    private var initialImageURL: String? // Зберігаємо початковий URL зображення

    init(recipe: RecipeListItem) {
        self.recipeId = recipe.id
        self.title = recipe.title
        self.instructions = recipe.instructions
        self.ingredients = recipe.ingredients
        self.category = recipe.categories
        self.difficulty = recipe.difficulty
        self.imageURL = recipe.imageURL
        self.initialImageURL = recipe.imageURL
        self.isPublic = recipe.isPublic
        self.isGlutenFree = recipe.isGlutenFree
        self.isVegan = recipe.isVegan
        self.isVegetarian = recipe.isVegetarian
        self.isDairyFree = recipe.isDairyFree
        self.isNutFree = recipe.isNutFree
        self.isKidsFree = recipe.isKidsFree
    }

    func save(selectedImage: UIImage?) {
        guard canSave else {
            showAlert = true
            return
        }

        guard let uId = Auth.auth().currentUser?.uid, let recipeId = self.recipeId else {
            return
        }

        func updateRecipeInFirestore(imageURL: String?) {
            let updatedRecipe = RecipeListItem(
                id: recipeId,
                title: title,
                ingredients: ingredients,
                instructions: instructions,
                categories: category,
                difficulty: difficulty,
                imageURL: imageURL,
                createdDate: Date().timeIntervalSince1970, // Зберігаємо оригінальну дату створення
                isFavorite: false,
                isPublic: isPublic, // Зберігаємо оригінальний стан
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
                .document(recipeId)
                .setData(updatedRecipe.asDictionary()) { error in
                    if let error = error {
                        print("Error updating recipe: \(error.localizedDescription)")
                    } else {
                        print("Recipe updated successfully!")
                    }
                }
        }

        if let image = selectedImage {
            let storageRef = Storage.storage().reference()
                .child("users/\(uId)/recipes/\(recipeId).jpg")

            if let imageData = image.jpegData(compressionQuality: 0.8) {
                storageRef.putData(imageData) { _, error in
                    if error == nil {
                        storageRef.downloadURL { url, _ in
                            updateRecipeInFirestore(imageURL: url?.absoluteString)
                        }
                    } else {
                        updateRecipeInFirestore(imageURL: self.initialImageURL) // Зберегти попередній URL у разі помилки завантаження
                    }
                }
            } else {
                updateRecipeInFirestore(imageURL: self.initialImageURL)
            }
        } else {
            updateRecipeInFirestore(imageURL: self.imageURL) // Зберегти поточний URL, якщо зображення не змінювалося
        }
    }

    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard !instructions.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard !ingredients.isEmpty else { return false }
        return true
    }
}
