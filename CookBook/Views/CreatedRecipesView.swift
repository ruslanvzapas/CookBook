//
//  Created recipes.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 27.05.2025.
//

import SwiftUI

struct CreatedRecipesView: View {
    let userId: String
    @StateObject var viewModel: RecipeListViewViewModel
    @State private var showingSortOptions = false
    @State private var showingNewRecipeSheet = false
    
    init(userId: String) {
        self.userId = userId
        self._viewModel = StateObject(
            wrappedValue: RecipeListViewViewModel(
                userId: userId,
                loadPublicRecipes: false
            )
        )
    }
    
    var body: some View {
        NavigationView {
            
                ScrollView {
                    VStack(alignment: .leading) {
                        // Поле для пошуку та кнопка сортування
                        HStack(spacing: 8) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(Color(.systemGray2))
                                    .padding(.leading, 10)
                                TextField("Search BUO®", text: $viewModel.searchText)
                                    .padding(.vertical, 10)
                                    .padding(.leading, 5)
                            }
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            
                            Button {
                                showingSortOptions = true
                            } label: {
                                Image(systemName: "arrow.up.arrow.down")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(width: 46, height: 46)
                                    .background(Color("brown-500"))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.vertical, 12)
                        
                        Spacer(minLength: 0)
                        
                        // Передаємо viewModel у RecipeListG
                        RecipeListG(viewModel: viewModel)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .navigationTitle("Search Recipes")
                    .sheet(isPresented: $showingSortOptions) {
                        SortOptionsView(viewModel: viewModel, isPresented: $showingSortOptions)
                    }
                }
     
        }
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

#Preview {
    CreatedRecipesView(userId: "JbVXZ5lI8XQR30TCdBBMDCMk1Td2")
}

