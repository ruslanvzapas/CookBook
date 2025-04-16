//
//  ContentView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    @State private var activeTab: TabItem = .main

        var body: some View {
            if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                TabBarView(activeTab: $activeTab, userId: viewModel.currentUserId)
            } else {
                LoginView()
            }
        }
    }
    
//    @ViewBuilder
//    var accountView: some View {
//        TabView {
//            ProductListView(userId: viewModel.currentUserId)
//                .tabItem {
//                    Label("Products", systemImage: "list.bullet")
//                }
//            ProfileView()
//                .tabItem {
//                    Label("Profile", systemImage: "person.circle")
//                }
//        }
//    }
//}


#Preview {
    MainView()
}
