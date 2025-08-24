//
//  ProductListItemViewViewModel.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class ProductListItemViewViewModel: ObservableObject {
    init() {}
    
    func toggleIsDone(item: ProductListItem) {
        var itemCopy = item
        itemCopy.setDone(!item.isDone)

        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()
        
        db.collection("users")
            .document(uid)
            .collection("products")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary()) 
    }
    
}
