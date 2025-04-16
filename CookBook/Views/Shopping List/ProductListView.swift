//
//  ProductListView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import FirebaseFirestore
import SwiftUI

struct ProductListView: View {
    @StateObject var viewModel: ProductListViewViewModel
    @FirestoreQuery var items: [ProductListItem]
    

    init(userId: String) {
        self._items = FirestoreQuery(
            collectionPath: "users/\(userId)/products"
        )
        self._viewModel = StateObject(
            wrappedValue: ProductListViewViewModel(userId: userId)
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(items) { item in
                    ProductListItemView(item: item)
                        .swipeActions {
                            Button {
                                viewModel.delete(id: item.id)
                            } label: {
                                Text("Delete")
                                    .tint(.red)
                            }
                        }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Product List")
            .toolbar {
                Button {
                    viewModel.showingNewItemView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewItemView(newItemPresented: $viewModel.showingNewItemView)
            }
        }
    }
}

#Preview {
    ProductListView(userId: "B1xpwSkHdocXfhVqixwHyNZdQdh2")
}
