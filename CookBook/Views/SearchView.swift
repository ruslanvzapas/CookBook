//
//  SearchView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 16.04.2025.
//

import SwiftUI

struct SearchView: View {
    let userId: String
    @StateObject var viewModel: RecipeListViewViewModel
    @State private var showingSortOptions = false
    @Binding var selectedRecipeID: String?
    
    init(userId: String, selectedRecipeID: Binding<String?>) {
        self.userId = userId
        self._viewModel = StateObject(
            wrappedValue: RecipeListViewViewModel(userId: userId, loadPublicRecipes: true)
        )
        self._selectedRecipeID = selectedRecipeID
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    SearchAndSortView(
                        searchText: $viewModel.searchText,
                        showingSortOptions: $showingSortOptions
                    )
                    
                    Spacer(minLength: 0)

                    RecipeListG(viewModel: viewModel)

                    RecipeNavigationLink(
                        selectedRecipeID: $selectedRecipeID,
                        viewModel: viewModel,
                        userId: userId
                    )
                    
                    
                }
                .padding(.horizontal)
                .padding(.bottom)
                .navigationTitle("Search Recipes")
                .sheet(isPresented: $showingSortOptions) {
                    SortOptionsView(viewModel: viewModel, isPresented: $showingSortOptions)
                }
            }
        }
    }
}

struct RecipeNavigationLink: View {
    @Binding var selectedRecipeID: String?
    @StateObject var viewModel: RecipeListViewViewModel
    var userId: String

    var body: some View {
        NavigationLink(
            destination: destinationView,
            isActive: Binding(
                get: { selectedRecipeID != nil },
                set: { newValue in
                    if !newValue {
                        selectedRecipeID = nil
                    }
                }
            ),
            label: { EmptyView() }
        )
        .hidden()
    }

    @ViewBuilder
    private var destinationView: some View {
        if let selectedID = selectedRecipeID,
           let selectedRecipe = viewModel.recipes.first(where: { $0.id == selectedID }) {
            RecipeDetailView(item: selectedRecipe, listViewModel: viewModel, userId: userId)
        } else {
            EmptyView()
        }
    }
}





struct SearchAndSortView: View {
    @Binding var searchText: String
    @Binding var showingSortOptions: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            // Поле пошуку
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(.systemGray2))
                    .padding(.leading, 10)
                TextField("Search BUO®", text: $searchText)
                    .padding(.vertical, 10)
                    .padding(.leading, 5)
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)

            // Кнопка сортування
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
    }
}


struct SortOptionsView: View {
    @ObservedObject var viewModel: RecipeListViewViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            Form {
                ForEach(SortOption.allCases) { option in
                    HStack {
                        Text(option.rawValue)
                        Spacer()
                        if viewModel.sortOption == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.sortOption = option
                        isPresented = false
                    }
                }
            }
            .navigationTitle("Sort By")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView(
        userId: "JbVXZ5lI8XQR30TCdBBMDCMk1Td2",
        selectedRecipeID: .constant(nil)
    )
}


/* if let selectedRecipe = viewModel.recipes.first(where: { $0.id == selectedRecipeID }) {
 NavigationLink(
 destination: RecipeDetailView(item: selectedRecipe, listViewModel: viewModel, userId: userId),
 isActive: Binding(
 get: { selectedRecipeID != nil },
 set: { newValue in
 if !newValue {
 selectedRecipeID = nil
 }
 }
 )
 ) {
 EmptyView()
 }
 .hidden()*/
