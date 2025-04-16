//
//  NewItemView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import SwiftUI
import PhotosUI

struct NewRecipeItemView: View {
    @ObservedObject var viewModel = NewRecipeItemViewViewModel()
    @Binding var newItemPresented: Bool
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                // Title section
                TextField("Enter recipe title", text: $viewModel.title)
                
                TextEditor(text: $viewModel.instructions)
                    .frame(minHeight: 100)
                
                // Image selection
                Section(header: Text("Image")) {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                    
                    Button("Select Image") {
                        showingImagePicker = true
                    }
                    .sheet(isPresented: $showingImagePicker, onDismiss: {
                        // Do something
                    }, content: {
                        ImagePickerView(selectedImage: $viewModel.selectedImage)
                    })
                }
                
                // Category and difficulty
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
                
                // Ingredients
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
                
                // Dietary filters
                Section(header: Text("Dietary Filters")) {
                    Toggle("Gluten Free", isOn: $viewModel.isGlutenFree)
                    Toggle("Vegan", isOn: $viewModel.isVegan)
                    Toggle("Vegetarian", isOn: $viewModel.isVegetarian)
                    Toggle("Dairy Free", isOn: $viewModel.isDairyFree)
                    Toggle("Nut Free", isOn: $viewModel.isNutFree)
                    Toggle("Kids Friendly", isOn: $viewModel.isKidsFree)
                }
                
                // Save button
                Button("Save") {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pink)
                .cornerRadius(8)
            }
            .navigationTitle("New Recipe")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Please fill in all required fields.")
                )
            }
        }
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No updates needed
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


#Preview {
    NewRecipeItemView(newItemPresented: Binding(get: {
        return true
    }, set: {
        _ in
    }))
}
