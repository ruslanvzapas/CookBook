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
    @State private var showingSortOptions = false

    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    init(userId: String) {
        self._viewModel = StateObject(
            wrappedValue: RecipeListViewViewModel(userId: userId)
        )
    }

    var body: some View {
        NavigationView {
            /*    VStack {
             // Поле для пошуку та кнопка сортування
             HStack(spacing: 8) { // Додаємо невеликий spacing між полем пошуку та кнопкою
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
             .frame(width: 46, height: 46) // Задаємо фіксовану ширину та висоту
             .background(Color("brown-500")) 
             .cornerRadius(10)
             }
             }
             .padding(.horizontal)
             .padding(.vertical, 12)
             
             
             ScrollView {
             LazyVGrid(columns: columns, spacing: 16) {
             ForEach(viewModel.filteredRecipes) { item in
             NavigationLink(destination: RecipeDetailView(item: item)) {
             RecipeListItemView(item: item)
             }
             }
             }
             .padding(.horizontal)
             .padding(.bottom)
             }
             }
             .navigationTitle("All Recipes")
             .toolbar {
             ToolbarItem(placement: .navigationBarTrailing) {
             Button {
             viewModel.showingNewItemView = true
             } label: {
             Image(systemName: "plus")
             }
             }
             }
             .sheet(isPresented: $viewModel.showingNewItemView) {
             NewRecipeItemView(newItemPresented: $viewModel.showingNewItemView)
             }
             .sheet(isPresented: $showingSortOptions) {
             SortOptionsView(viewModel: viewModel, isPresented: $showingSortOptions)
             }
             }*/
        }
    }
}

#Preview {
    RecipeListView(userId: "JbVXZ5lI8XQR30TCdBBMDCMk1Td2")
}
