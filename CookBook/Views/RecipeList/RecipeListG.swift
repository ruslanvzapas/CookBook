//
//  RecipeListG.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 17.04.2025.
//

import SwiftUI
import FirebaseFirestore

struct RecipeListG: View {
    @ObservedObject var viewModel: RecipeListViewViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.displayedRecipes) { item in
                NavigationLink(
                    destination: RecipeDetailView(item: item, listViewModel: viewModel, userId: viewModel.userId)
                ) {
                    RecipeListItemView(item: item)
                        .frame(maxHeight: .infinity, alignment: .top)
                }
            }
        }
    }
}

#Preview {
    RecipeListG(viewModel: RecipeListViewViewModel(userId: "testUser"))
}
