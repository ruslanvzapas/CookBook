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
    
    // Дієтичні фільтри
    @Published var isGlutenFree: Bool = false
    @Published var isVegan: Bool = false
    @Published var isVegetarian: Bool = false
    @Published var isDairyFree: Bool = false
    @Published var isNutFree: Bool = false
    @Published var isKidsFree: Bool = false
    
    @Published var showAlert: Bool = false
    @Published var selectedImage: UIImage? = nil
    
    init() {}
    
    func save() {
            guard canSave else {
                showAlert = true
                return
            }

            guard let uId = Auth.auth().currentUser?.uid else {
                return
            }

            uploadPhoto { [weak self] url in
                let newId = UUID().uuidString
                let newRecipe = RecipeListItem(
                    id: newId,
                    title: self?.title ?? "",
                    ingredients: self?.ingredients ?? [],
                    instructions: self?.instructions ?? "",
                    categories: self?.category ?? .main,
                    difficulty: self?.difficulty ?? .easy,
                    imageURL: url,
                    createdDate: Date().timeIntervalSince1970,
                    isFavorite: false,
                    isGlutenFree: self?.isGlutenFree ?? false,
                    isVegan: self?.isVegan ?? false,
                    isVegetarian: self?.isVegetarian ?? false,
                    isDairyFree: self?.isDairyFree ?? false,
                    isNutFree: self?.isNutFree ?? false,
                    isKidsFree: self?.isKidsFree ?? false
                )

                let db = Firestore.firestore()
                db.collection("users")
                    .document(uId)
                    .collection("recipes")
                    .document(newId)
                    .setData(newRecipe.asDictionary())
            }
        }

        var canSave: Bool {
            guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
            guard !instructions.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
            guard !ingredients.isEmpty else { return false }
            return true
        }

    func uploadPhoto(completion: @escaping (String?) -> Void) {
        //Make sure that the selected image property isn't nil
        guard let selectedImage = selectedImage else {
            completion(nil)
            return
        }
        
        //Create storage reference
        let storageRef = Storage.storage().reference()
        
        //Turn our image into data
        let imageData = selectedImage.jpegData(compressionQuality: 0.6)
        
        guard let imageData = imageData else {
            completion(nil)
            return
        }
        
        //Specify the file path and name
        let path = "image/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        
        //Upload that data
        let uploadTask = fileRef.putData(imageData, metadata: nil) {
            metadata, error in
            
            //Check for errors
            if error == nil && metadata != nil {
                
                //Save a reference to the file in Firestore
                fileRef.downloadURL { url, error in
                    if let downloadURL = url {
                        completion(downloadURL.absoluteString)
                        return
                    } else {
                        completion(nil)
                        return
                    }
                }
            } else {
                completion(nil)
                return
            }
        }
    }
}
