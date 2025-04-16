//
//  ProductListView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import FirebaseFirestore
import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel: RecipeListViewViewModel
    @FirestoreQuery var items: [RecipeListItem]
    
    init(userId: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/recipes"
        )
        self._viewModel = StateObject(
            wrappedValue: RecipeListViewViewModel(userId: userId)
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(items) { item in
                    RecipeListItemView(item: item)
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.delete(id: item.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .listStyle(.plain)
            }
            .navigationTitle("My Recipes")
            .toolbar {
                Button {
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewRecipeItemView(newItemPresented: $viewModel.showingNewItemView)
            }
        }
    }
}

#Preview {
    RecipeListView(userId: "B1xpwSkHdocXfhVqixwHyNZdQdh2")
}
