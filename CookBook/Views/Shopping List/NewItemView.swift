//
//  NewItemView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import SwiftUI

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var newItemPresented: Bool
    
    var body: some View {
        VStack {
            Text("New Item")
                .font(.system(size: 32))
                .bold()
                .padding(.top, 24)
            
            Form {
                // Title
                TextField("Title", text: $viewModel.title)
                    .textFieldStyle(PlainTextFieldStyle())
                
                // Quantity
                TextField("Quantity", text: $viewModel.quantity)
                        .textFieldStyle(PlainTextFieldStyle())
                
                // Button
                CBButton(title: "Save",
                         backgroundColor: .pink,
                         height: 40
                ) {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Please, fill all fields")
                )
            }
        }
    }
}

#Preview {
    NewItemView(newItemPresented: Binding(get: {
        return true
    }, set: {
        _ in
    }))
}
