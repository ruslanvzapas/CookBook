//
//  LoginView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    
    var body: some View {
        NavigationView {
            VStack {
                //Header
                VStack {
                    Text("BUO")
                        .font(.system(size: 50))
                        .bold()
                    Text("Get things done")
                        .font(.system(size: 24))
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(Color.red)
                }
                
                VStack {
                    Form {
                        TextField("Email Address", text: $viewModel.email)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .textInputAutocapitalization(.none)
                            .autocorrectionDisabled()
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(DefaultTextFieldStyle())
                    }
                    
                    CBButton(
                        title: "Log In",
                        backgroundColor: Color.green,
                        height: 50.0) {
                            viewModel.login()
                        }
                }
                
                //Create
                VStack {
                    Text("New around here?")
                    NavigationLink(
                        "Create An Account",
                        destination: RegisterView()
                    )
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
