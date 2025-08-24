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
    @State private var selectedRecipeID: String? = nil


    @EnvironmentObject var router: Router

    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            TabBarView(
                activeTab: $activeTab,
                selectedRecipeID: $selectedRecipeID,
                userId: viewModel.currentUserId
            )
                .onChange(of: router.deepLinkedRecipeID) {
                    if let id = router.deepLinkedRecipeID {
                        openRecipe(withId: id)
                    }
                }
        } else {
            LoginView()
        }
    }

    func openRecipe(withId id: String) {
        selectedRecipeID = id
        activeTab = .search
    }

}

#Preview {
    MainView()
}
