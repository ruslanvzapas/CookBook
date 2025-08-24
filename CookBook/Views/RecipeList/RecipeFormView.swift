//
//  NewItemView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 24.08.2025.
//

import SwiftUI

struct RecipeFormView: View {
    @StateObject var viewModel: RecipeFormViewModel
    @Binding var isPresented: Bool
    
    @State private var isPickerShowing = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView {
            Form {
                // Section for image
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
                
                // General information section
                Section(header: Text("Recipe Details")) {
                    TextField("Enter recipe title", text: $viewModel.title)
                    TextEditor(text: $viewModel.instructions)
                        .frame(minHeight: 100)
                }
                
                // Category and difficulty section
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
                
                // Ingredients section
                Section(header: Text("Ingredients")) {
                    ForEach($viewModel.ingredients.indices, id: \.self) { index in
                        TextField("Ingredient \(index + 1)", text: $viewModel.ingredients[index].title)
                        TextField("Quantity \(index + 1)", text: $viewModel.ingredients[index].quantity)
                    }
                    .onDelete { indexSet in
                        viewModel.ingredients.remove(atOffsets: indexSet)
                    }
                    Button("Add Ingredient") {
                        viewModel.ingredients.append(ProductListItem(id: UUID().uuidString, title: "", quantity: "", isDone: false))
                    }
                }
                
                // Visibility and dietary filters section
                Section(header: Text("Visibility & Dietary Filters")) {
                    Toggle("Public", isOn: $viewModel.isPublic)
                    Toggle("Gluten Free", isOn: $viewModel.isGlutenFree)
                    Toggle("Vegan", isOn: $viewModel.isVegan)
                    Toggle("Vegetarian", isOn: $viewModel.isVegetarian)
                    Toggle("Dairy Free", isOn: $viewModel.isDairyFree)
                    Toggle("Nut Free", isOn: $viewModel.isNutFree)
                    Toggle("Kids Friendly", isOn: $viewModel.isKidsFree)
                }
                
                // Save button
                Button("Save") {
                    viewModel.save(selectedImage: selectedImage) {
                        isPresented = false
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
            }
            .navigationTitle(viewModel.isEditing ? "Edit Recipe" : "New Recipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text("Please fill in all required fields."))
            }
        }
        .sheet(isPresented: $isPickerShowing) {
            ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
        }
    }
}
