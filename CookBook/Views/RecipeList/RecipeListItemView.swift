//
//  ProductListItemsView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//
import SwiftUI
import FirebaseFirestore

struct RecipeListItemView: View {
    @StateObject var viewModel = RecipeListItemViewViewModel()
    let item: RecipeListItem
    @State private var isFavorite: Bool
    @State private var showFavoriteMessage = false
    @State private var favoriteMessage = ""

    var cardWidth: CGFloat {
        (UIScreen.main.bounds.width - 16 * 3) / 2
    }

    var imageHeight: CGFloat {
        cardWidth * (219 / 177)
    }


    init(item: RecipeListItem) {
        self.item = item
        _isFavorite = State(initialValue: item.isFavorite)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                // Зображення або заглушка
                if let imageURL = item.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: cardWidth, height: imageHeight)
                                .background(Color.gray.opacity(0.1))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: cardWidth, height: imageHeight)
                                .clipped()
                        case .failure(_):
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: cardWidth, height: imageHeight)
                                .background(Color.gray.opacity(0.1))
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(width: cardWidth, height: imageHeight)
                        .background(Color.gray.opacity(0.1))
                }

                // Верхній вміст (час і серце)
                VStack {
                    HStack {
                        Text("30 min")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color("#FDEDCE"))
                            .clipShape(RoundedRectangle(cornerRadius: 33))
                            .padding(8)
                        Spacer()
                    }

                    Spacer()

                    HStack {
                        Spacer()
                        Button {
                            isFavorite.toggle()
                            viewModel.toggleIsFavorite(for: item)

                            favoriteMessage = isFavorite ? "Recipe added to favorites" : "Recipe removed from favorites"
                            withAnimation {
                                showFavoriteMessage = true
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showFavoriteMessage = false
                                }
                            }
                        } label: {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(isFavorite ? Color("brown-500") : .black)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(8)
                    }
                }
            }
            .frame(width: cardWidth, height: imageHeight)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                // Повідомлення
                Group {
                    if showFavoriteMessage {
                        Text(favoriteMessage)
                            .font(.caption)
                            .padding(10)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .padding(.top, 12)
                    }
                },
                alignment: .center
            )

            // Назва рецепта
            Text(item.title)
                .font(.system(size: 18))
                .lineLimit(2)
                .truncationMode(.tail)
                .foregroundStyle(Color.black)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: cardWidth)
        .cornerRadius(12)
    }
}


#Preview {
    RecipeListItemView(item: RecipeListItem(
        id: "1",
        title: "Супер довга назва для веганської піци з салатом та цукіні, яка займає два рядки",
        ingredients: [],
        instructions: "Змішайте всі інгредієнти...",
        categories: .main,
        difficulty: .medium,
        imageURL: "https://firebasestorage.googleapis.com:443/v0/b/cookbook-5ab57.firebasestorage.app/o/users%2Fn6QMWY5MmQUra5i57ztZgUG7rCw1%2Frecipes%2FACC296CC-EF3A-4B02-9E5B-366B8A3CABA5.jpg?alt=media&token=b3cb7bea-21d1-47e7-ad63-0b43cd22436d",
        createdDate: Date().timeIntervalSince1970,
        isFavorite: true, isPublic: false,
        isGlutenFree: true,
        isVegan: true,
        isVegetarian: true,
        isDairyFree: false,
        isNutFree: false,
        isKidsFree: false
    ))
    .padding()
}

/*var body: some View {
HStack {
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
}*/
