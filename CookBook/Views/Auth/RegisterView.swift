//
//  RegisterView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    
    var body: some View {
        VStack {
            //Header
            VStack {
                Text("Register")
                    .font(.system(size: 50))
                    .bold()
                Text("Get things done")
                    .font(.system(size: 24))
            }
            
            //Register
            VStack {
                Form {
                    TextField("Full Name", text: $viewModel.name)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .textInputAutocapitalization(.none)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                }
                
                Spacer() // Отталкивает кнопку вниз
                
                CBButton(
                    title: "Create an account",
                    backgroundColor: Color.yellow,
                    height: 50.0
                ) {
                    //Action
                    viewModel.register()
                }
            }
            
        }
    }
}


#Preview {
    RegisterView()
}
