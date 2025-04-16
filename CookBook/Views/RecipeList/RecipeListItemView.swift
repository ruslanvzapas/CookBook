//
//  ProductListItemsView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import SwiftUI

import SwiftUI

struct RecipeListItemView: View {
    @StateObject var viewModel = RecipeListItemViewViewModel()
    let item: RecipeListItem
    @State private var isFavorite: Bool

    init(item: RecipeListItem) {
        self.item = item
        _isFavorite = State(initialValue: item.isFavorite)
    }

    var body: some View {
        HStack(alignment: .top) { // Додано вирівнювання .top для кращого розміщення зображення та тексту
            // Зображення
            AsyncImagePhaseView(url: item.imageURL, width: 80, height: 80)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.title)
                        .font(.headline)
                        .lineLimit(1)

                    Button {
                        isFavorite.toggle()
                        viewModel.toggleIsFavorite(for: item)
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                }

                Text(item.categories.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Difficulty: \(item.difficulty.rawValue)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    RecipeListItemView(item: RecipeListItem(
        id: "1",
        title: "Vegan Tacos",
        ingredients: [],
        instructions: "Mix all ingredients...",
        categories: .main,
        difficulty: .medium,
        imageURL: "https://firebasestorage.googleapis.com/v0/b/cookbook-5ab57.appspot.com/o/images%2F7E470E2A-9951-4717-9331-2C8E2E2B8351.jpg?alt=media&token=4e100d04-46d4-4674-a31d-585e29d977d2",
        createdDate: Date().timeIntervalSince1970,
        isFavorite: true,
        isGlutenFree: true,
        isVegan: true,
        isVegetarian: true,
        isDairyFree: false,
        isNutFree: false,
        isKidsFree: false
    ))
}
