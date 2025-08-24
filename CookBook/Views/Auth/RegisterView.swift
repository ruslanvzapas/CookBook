//
//  RegisterView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

/*import SwiftUI

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
*/

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
    @State private var rememberMe = false

    private let brandRed = Color(red: 0.63, green: 0.12, blue: 0.12) // під твій скрін

    var body: some View {
        VStack(spacing: 24) {

            // Лого
            Text("BUO")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(brandRed)
                .padding(.top, 60)

            // Заголовки
            VStack(spacing: 8) {
                Text("Create your account")
                    .font(.title2).fontWeight(.semibold)

                Text("Save, share, and discover recipes you love.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)

            // Поля
            VStack(spacing: 16) {
                TextField("Name", text: $viewModel.name)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding().background(Color(.systemGray6)).cornerRadius(12)
                    .autocorrectionDisabled()

                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding().background(Color(.systemGray6)).cornerRadius(12)
                    .textInputAutocapitalization(.none)
                    .autocorrectionDisabled()

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding().background(Color(.systemGray6)).cornerRadius(12)
            }
            .padding(.horizontal, 16)

            // Remember me (кастомний чекбокс)
            Toggle(isOn: $rememberMe) {
                Text("Remember me").font(.subheadline)
            }
            .toggleStyle(CheckboxStyle(tint: brandRed))
            .padding(.horizontal, 16)

            // Sign Up
            Button {
                viewModel.register()
            } label: {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(brandRed)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 16)

            // Divider
            HStack {
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                Text("Or continue with").font(.caption).foregroundColor(.secondary)
                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
            }
            .padding(.horizontal, 16)

            // Google & Apple
            HStack(spacing: 16) {
                Button { /* Google */ } label: {
                    HStack {
                        Image(systemName: "globe") // тимчасово, підстав свій логотип
                        Text("Google")
                    }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }

                Button { /* Apple */ } label: {
                    HStack {
                        Image(systemName: "applelogo")
                        Text("Apple")
                    }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 16)

            Spacer()

            // Лінк логіну
            HStack(spacing: 4) {
                Text("Already have an account?").foregroundColor(.secondary)
                Button("Log in") { /* navigate to login */ }
                    .foregroundColor(brandRed)
            }
            .font(.footnote)
            .padding(.bottom, 16)
        }
    }
}

/// Кастомний чекбокс-стиль для iOS
struct CheckboxStyle: ToggleStyle {
    var tint: Color = .accentColor

    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .imageScale(.large)
                    .foregroundColor(configuration.isOn ? tint : .secondary)

                configuration.label
                    .foregroundStyle(.primary)

                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RegisterView()
}


