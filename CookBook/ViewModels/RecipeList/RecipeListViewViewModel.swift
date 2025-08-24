//
//  ProductListViewViewModel.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import FirebaseFirestore
import Foundation
import Combine

enum SortOption: String, CaseIterable, Identifiable {
    var id: Self { self }
    case titleAscending = "Title (A-Z)"
    case titleDescending = "Title (Z-A)"
    case dateCreatedDescending = "Newest First"
    case dateCreatedAscending = "Oldest First"
}

class RecipeListViewViewModel: ObservableObject {
    @Published var showingNewItemView = false
    @Published var searchText = ""
    @Published var recipes: [RecipeListItem] = []
    @Published var sortOption: SortOption = .dateCreatedDescending
    @Published var shouldShowFavoritesOnly: Bool = false
    
    let userId: String
    private var firestoreListener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    private let loadPublicRecipes: Bool
    
    init(userId: String, shouldShowFavoritesOnly: Bool = false, loadPublicRecipes: Bool = false) {
        self.userId = userId
        self.loadPublicRecipes = loadPublicRecipes
        self.shouldShowFavoritesOnly = shouldShowFavoritesOnly
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { _ in }
            .store(in: &cancellables)
        
        if loadPublicRecipes {
            fetchPublicRecipes()
        } else {
            fetchRecipes()
        }
    }
    
    deinit {
        firestoreListener?.remove()
    }
    
    var displayedRecipes: [RecipeListItem] {
        var list = recipes
        
        if !loadPublicRecipes {
            if shouldShowFavoritesOnly {
                list = list.filter { $0.isFavorite }
            }
        }
        
        if !searchText.isEmpty {
            let lowercasedSearchText = searchText.lowercased()
            list = list.filter { $0.title.lowercased().contains(lowercasedSearchText) }
        }
        
        switch sortOption {
        case .titleAscending:
            list.sort { $0.title < $1.title }
        case .titleDescending:
            list.sort { $0.title > $1.title }
        case .dateCreatedDescending:
            list.sort { $0.createdDate > $1.createdDate }
        case .dateCreatedAscending:
            list.sort { $0.createdDate < $1.createdDate }
        }
        
        return list
    }
    
    func updateFavorite(for id: String, isFavorite: Bool) {
        if let index = recipes.firstIndex(where: { $0.id == id }) {
            recipes[index].isFavorite = isFavorite
        }
    }
    
    private func fetchRecipes() {
        let db = Firestore.firestore()
        firestoreListener = db.collection("users")
            .document(userId)
            .collection("recipes")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self?.recipes = documents.compactMap {
                    try? $0.data(as: RecipeListItem.self)
                    
                }
                print("Private fetched count: \(documents.count)")
            }
    }
    
    func fetchPublicRecipes() {
        print(" fetchPublicRecipes викликано")
        let db = Firestore.firestore()
        
        db.collectionGroup("recipes")
            .whereField("isPublic", isEqualTo: true)
            .getDocuments { [weak self] snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    print("Помилка при завантаженні публічних рецептів: \(error?.localizedDescription ?? "невідома помилка")")
                    return
                }
                
                DispatchQueue.main.async {
                    let loaded = documents.compactMap { document in
                        try? document.data(as: RecipeListItem.self)
                    }
                    print("Завантажено публічних рецептів: \(loaded.count)")
                    self?.recipes = loaded
                    
                    print(" fetchPublicRecipes завантажено")
                }
            }
        print("fetchPublicRecipes фініш")
    }
    
    func shareRecipe(id: String) {
        let urlString = "cookbook://recipe?id=\(id)"
        guard let url = URL(string: urlString) else { return }

        // активне вікно сцени
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {

            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            rootVC.present(activityVC, animated: true)
        }
    }

    func delete(id: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("recipes")
            .document(id)
            .delete()
    }
}

