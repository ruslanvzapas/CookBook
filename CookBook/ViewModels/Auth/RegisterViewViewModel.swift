//
//  RegisterViewViewModel.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//
import FirebaseFirestore
import FirebaseAuth
import Foundation

class RegisterViewViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    init() {}
    
    func register() {
        guard validate() else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] result, error in
            guard let userId = result?.user.uid else {
                return
            }
            self?.insertUserRecord(id: userId)
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id,
                           name: name,
                           email: email,
                           joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            return false
        }
        
        guard password.count >= 8 else {
            return false
        }
        
        return true
    }
}
