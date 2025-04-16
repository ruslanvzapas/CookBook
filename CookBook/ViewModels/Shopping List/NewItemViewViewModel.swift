//
//  NewItemViewViewModel.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class NewItemViewViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var quantity: String = ""
    // @Published var dueDate: Date = Date()
    @Published var showAlert: Bool = false
    
    init() {}
    
    func save() {
        guard canSave else {
            return
        }
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Create model
        let newId = UUID().uuidString
        let newItem = ProductListItem(
            id: newId,
            title: title,
            quantity: quantity,
         //   dueDate: dueDate.timeIntervalSince1970,
         //   createdDate: Date().timeIntervalSince1970,
            isDone: false
        )
        
        // Save model to the DB
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uId)
            .collection("products")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        guard !quantity.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        /*guard dueDate >= Date().addingTimeInterval(-86400) else {
            return false
        }*/
        
        return true
    }
}
