//
//  ProfileView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    // Avatar
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.blue)
                        .frame(width: 125, height: 124)
                    
                    // Info: Name, Email, Member since
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Name: ")
                            Text(user.name)
                        }
                        HStack {
                            Text("Email: ")
                            Text(user.email)
                        }
                        HStack {
                            Text("Member Since: ")
                            Text(Date(timeIntervalSince1970: user.joined).formatted(
                                    date: .abbreviated,
                                    time: .shortened))
                        }
                    }
                    
                    // Sign out
                    CBButton(
                        title: "Log out",
                        backgroundColor: Color.green,
                        height: 40) {
                            viewModel.logOut()
                        }
                } else {
                    Text("Loading...")
                }
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            viewModel.fetchUser()
        }
    }
}

#Preview {
    ProfileView()
}
