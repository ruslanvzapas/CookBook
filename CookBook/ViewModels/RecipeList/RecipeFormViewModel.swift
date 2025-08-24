//
//  ProductListViewViewModel.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 24.08.2025.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

// Створимо єдиний ViewModel, який буде керувати і створенням, і редагуванням
class RecipeFormViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var instructions: String = ""
    @Published var ingredients: [ProductListItem] = []
    @Published var category: RecipeCategory = .main
    @Published var difficulty: Difficulty = .easy
    @Published var imageURL: String? = nil
    @Published var isPublic: Bool = false
    @Published var isGlutenFree: Bool = false
    @Published var isVegan: Bool = false
    @Published var isVegetarian: Bool = false
    @Published var isDairyFree: Bool = false
    @Published var isNutFree: Bool = false
    @Published var isKidsFree: Bool = false
    
    @Published var showAlert: Bool = false
    
    private let recipeId: String // ID рецепту. Для нового він генерується
    let isEditing: Bool // Прапорець, що вказує, чи це режим редагування
    private let initialCreatedDate: TimeInterval // Зберігаємо дату створення
    
    // Ініціалізатор для створення нового рецепта
    init() {
        self.recipeId = UUID().uuidString
        self.isEditing = false
        self.initialCreatedDate = Date().timeIntervalSince1970
    }
    
    // Ініціалізатор для редагування існуючого рецепта
    init(recipe: RecipeListItem) {
        self.recipeId = recipe.id
        self.isEditing = true
        self.initialCreatedDate = recipe.createdDate
        
        self.title = recipe.title
        self.instructions = recipe.instructions
        self.ingredients = recipe.ingredients
        self.category = recipe.categories
        self.difficulty = recipe.difficulty
        self.imageURL = recipe.imageURL
        self.isPublic = recipe.isPublic
        self.isGlutenFree = recipe.isGlutenFree
        self.isVegan = recipe.isVegan
        self.isVegetarian = recipe.isVegetarian
        self.isDairyFree = recipe.isDairyFree
        self.isNutFree = recipe.isNutFree
        self.isKidsFree = recipe.isKidsFree
    }
    
    // Уніфікована функція збереження
    func save(selectedImage: UIImage?, completion: @escaping () -> Void) {
        guard canSave else {
            showAlert = true
            return
        }
        
        guard let uId = Auth.auth().currentUser?.uid else { return }
        
        // Внутрішня функція для збереження/оновлення даних у Firestore
        func saveRecipe(imageURL: String?) {
            let recipeToSave = RecipeListItem(
                id: self.recipeId,
                ownerId: uId, // ownerId потрібен лише при створенні
                title: self.title,
                ingredients: self.ingredients,
                instructions: self.instructions,
                categories: self.category,
                difficulty: self.difficulty,
                imageURL: imageURL,
                createdDate: self.initialCreatedDate,
                isFavorite: false, // Цю властивість треба керувати окремо
                isPublic: self.isPublic,
                isGlutenFree: self.isGlutenFree,
                isVegan: self.isVegan,
                isVegetarian: self.isVegetarian,
                isDairyFree: self.isDairyFree,
                isNutFree: self.isNutFree,
                isKidsFree: self.isKidsFree
            )
            
            let db = Firestore.firestore()
            db.collection("users")
                .document(uId)
                .collection("recipes")
                .document(self.recipeId)
                .setData(recipeToSave.asDictionary()) { error in
                    if let error = error {
                        print("Error saving recipe: \(error.localizedDescription)")
                    } else {
                        print("Recipe saved successfully!")
                        completion()
                    }
                }
        }
        
        // Логіка завантаження зображення
        if let image = selectedImage {
            let storageRef = Storage.storage().reference()
                .child("users/\(uId)/recipes/\(self.recipeId).jpg")
            
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                storageRef.putData(imageData) { _, error in
                    if error == nil {
                        storageRef.downloadURL { url, _ in
                            saveRecipe(imageURL: url?.absoluteString)
                        }
                    } else {
                        // Якщо завантаження не вдалося, зберігаємо рецепт без нового зображення
                        saveRecipe(imageURL: self.imageURL)
                    }
                }
            } else {
                saveRecipe(imageURL: self.imageURL)
            }
        } else {
            // Якщо зображення не вибране, просто зберігаємо рецепт
            saveRecipe(imageURL: self.imageURL)
        }
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !instructions.trimmingCharacters(in: .whitespaces).isEmpty,
              !ingredients.isEmpty else {
            return false
        }
        return true
    }
}
