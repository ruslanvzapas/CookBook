//
//  RecipeDetailView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 17.04.2025.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var listViewModel: RecipeListViewViewModel
    let userId: String
    @State private var showingEditView = false
    let item: RecipeListItem
    var activeTags: [(title: String, isActive: Bool, color: Color)] {
        [
            ("Gluten-Free", item.isGlutenFree, .gray),
            ("Vegan", item.isVegan, .mint),
            ("Vegetarian", item.isVegetarian, .teal),
            ("Dairy-Free", item.isDairyFree, .blue),
            ("Nut-Free", item.isNutFree, .orange),
            ("Kids-Free", item.isKidsFree, .purple)
        ]
    }
    
    init(item: RecipeListItem, listViewModel: RecipeListViewViewModel, userId: String) {
        self.item = item
        self.listViewModel = listViewModel
        self.userId = userId
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageURL = item.imageURL, let url = URL(string: imageURL) {
                    ZStack(alignment: .top) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 350)
                                    .frame(maxWidth: .infinity)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 350)
                                    .clipped()
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)
                                    .foregroundColor(.gray)
                                
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    ForEach(activeTags.filter { $0.isActive }, id: \.title) { tag in
                        TagLabelView(title: tag.title, color: tag.color)
                    }
                }
                .padding(.horizontal)
                
                Text(item.title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                InfoRowView(
                    iconName: "star.fill",
                    label: "Difficulty",
                    value: item.difficulty.rawValue,
                    iconColor: Color("brown-500")
                )
                InfoRowView(
                    iconName: "fork.knife",
                    label: "Category",
                    value: item.categories.rawValue,
                    iconColor: Color("brown-500")
                )
                
                Text("Instructions")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                
                Text(item.instructions)
                    .padding(.horizontal)
                
                Text("Ingriedients")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                
                ForEach(item.ingredients, id: \.title) { ingredient in
                    HStack {
                        Text(ingredient.title)
                            .font(.body)
                        Spacer()
                        Text(ingredient.quantity)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color("brown-500"))
                    .padding(14)
                    .background(Color.white)
                    .clipShape(Circle())
                
            }
            .shadow(radius: 2)
            .foregroundColor(Color("brown-500"))
        }, trailing: Menu {
            if item.ownerId == userId {
                Button(action: {
                    showingEditView = true
                }) {
                    Label("Редагувати", systemImage: "pencil")
                }
            }
            Button(action: {
                let productViewModel = ProductListViewViewModel(userId: userId)
                productViewModel.addIngredientsFromRecipe(item.ingredients)
            }) {
                Label("Додати до кошика", systemImage: "cart")
            }
            
            if item.isPublic, let url = item.publicURL {
                Button(action: {
                    let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let rootVC = windowScene.windows.first?.rootViewController {
                        rootVC.present(av, animated: true)
                    }
                }) {
                    Label("Поширити", systemImage: "square.and.arrow.up")
                }
            }
            
            Button(role: .destructive, action: {
                listViewModel.delete(id: item.id)
                dismiss()
            }) {
                Label("Видалити", systemImage: "trash")
            }
        } label: {
            HStack {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color("brown-500"))
                    .padding(17)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .shadow(radius: 2)
            .foregroundColor(Color("brown-500"))
        }
        )
        .sheet(isPresented: $showingEditView) {
            let viewModel = EditRecipeItemViewViewModel(recipe: item)
            EditRecipeItemView(viewModel: viewModel, isPresented: $showingEditView)
                .environmentObject(listViewModel) 
        }
        .edgesIgnoringSafeArea(.top)
    }
    
}

struct InfoRowView: View {
    let iconName: String
    let label: String
    let value: String
    let iconColor: Color

    var body: some View {
        HStack {
            Circle()
                .fill(iconColor)
                .frame(width: 49, height: 49)
                .overlay(
                    Image(systemName: iconName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                )
            VStack(alignment: .leading) {
                Text(label)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color("gray-700"))
                    .padding(.bottom, 0.1)
                Text(value)
                    .font(.system(size: 16, weight: .medium))
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    let mockViewModel = RecipeListViewViewModel(userId: "mock_user")
    let mockRecipe = RecipeListItem(
        id: "1",
        title: "Vegan Tacos",
        ingredients: [
            ProductListItem(id: UUID().uuidString, title: "Flour", quantity: "200g", isDone: false),
            ProductListItem(id: UUID().uuidString, title: "Milk", quantity: "250ml", isDone: false),
            ProductListItem(id: UUID().uuidString, title: "Eggs", quantity: "2", isDone: false)
        ],
        instructions: "1. Chop veggies\n2. Mix them all\n3. Enjoy!",
        categories: .main,
        difficulty: .medium,
        imageURL: "https://firebasestorage.googleapis.com:443/v0/b/cookbook-5ab57.firebasestorage.app/o/users%2FJbVXZ5lI8XQR30TCdBBMDCMk1Td2%2Frecipes%2FF5AE1430-CFC3-472A-859D-0AB62B3FBA84.jpg?alt=media&token=d24da8c6-e05b-4f34-8f7b-12900dba73cd",
        createdDate: Date().timeIntervalSince1970,
        isFavorite: true, isPublic: false,
        isGlutenFree: true,
        isVegan: true,
        isVegetarian: false,
        isDairyFree: false,
        isNutFree: false,
        isKidsFree: false
    )

    RecipeDetailView(item: mockRecipe, listViewModel: mockViewModel, userId: "mock_user")
}
