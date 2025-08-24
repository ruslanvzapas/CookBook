//
//  EditRecipeItemView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 15.05.2025.
//

import SwiftUI

struct EditRecipeItemView: View {
    @StateObject var viewModel: EditRecipeItemViewViewModel
    @Binding var isPresented: Bool
    @State private var isPickerShowing = false
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Image")) {
                    if let imageURL = viewModel.imageURL, selectedImage == nil, let url = URL(string: imageURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 200)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }

                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }

                    Button("Select Photo") {
                        isPickerShowing = true
                    }
                }

                TextField("Enter recipe title", text: $viewModel.title)

                TextEditor(text: $viewModel.instructions)
                    .frame(minHeight: 100)

                Section(header: Text("Category & Difficulty")) {
                    Picker("Category", selection: $viewModel.category) {
                        ForEach(RecipeCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }

                    Picker("Difficulty", selection: $viewModel.difficulty) {
                        ForEach(Difficulty.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                }

                ForEach($viewModel.ingredients.indices, id: \.self) { index in
                    TextField(
                        "Ingredient \(index + 1)",
                        text: $viewModel.ingredients[index].title
                    )
                    TextField(
                        "Quantity \(index + 1)",
                        text: $viewModel.ingredients[index].quantity
                    )
                }

                Button("Add Ingredient") {
                    viewModel.ingredients.append(
                        ProductListItem(
                            id: UUID().uuidString,
                            title: "",
                            quantity: "",
                            isDone: false
                        )
                    )
                }
                
                Section(header: Text("Visibility")) {
                    Toggle("Public", isOn: $viewModel.isPublic)
                }

                Section(header: Text("Dietary Filters")) {
                    Toggle("Gluten Free", isOn: $viewModel.isGlutenFree)
                    Toggle("Vegan", isOn: $viewModel.isVegan)
                    Toggle("Vegetarian", isOn: $viewModel.isVegetarian)
                    Toggle("Dairy Free", isOn: $viewModel.isDairyFree)
                    Toggle("Nut Free", isOn: $viewModel.isNutFree)
                    Toggle("Kids Friendly", isOn: $viewModel.isKidsFree)
                }

                Button("Save") {
                    viewModel.save(selectedImage: selectedImage)
                    isPresented = false
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue) // Змінимо колір для відмінності
                .cornerRadius(8)
            }
            .navigationTitle("Edit Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Please fill in all required fields.")
                )
            }
        }
        .sheet(isPresented: $isPickerShowing) {
            ImagePicker(
                selectedImage: $selectedImage,
                isPickerShowing: $isPickerShowing
            )
        }
    }
}

#Preview {
    let mockRecipe = RecipeListItem(
        id: "mock_id",
        title: "Mock Recipe",
        ingredients: [
            ProductListItem(id: UUID().uuidString, title: "Ingredient 1", quantity: "1 cup", isDone: false)
        ],
        instructions: "Mock instructions.",
        categories: .main,
        difficulty: .easy,
        createdDate: Date().timeIntervalSince1970,
        isFavorite: false, isPublic: false
        
    )
    let mockViewModel = EditRecipeItemViewViewModel(recipe: mockRecipe)
    @State var isPresented = true // Для прев'ю ми можемо встановити true

    EditRecipeItemView(viewModel: mockViewModel, isPresented: $isPresented)
}
