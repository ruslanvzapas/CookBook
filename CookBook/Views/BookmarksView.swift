//
//  FavoritesView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 06.02.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct BookmarksView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var listViewModel: RecipeListViewViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                RecipeListG(viewModel: listViewModel)
                     .navigationTitle("Bookmarks") 
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .onAppear {
            listViewModel.shouldShowFavoritesOnly = true
        }
        .onDisappear {
            listViewModel.shouldShowFavoritesOnly = false
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color("brown-500"))
                            .padding(14)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .shadow(radius: 2)
                }
            }
        }
    }
}




#Preview {
    let viewModel = RecipeListViewViewModel(userId: "testUserId")
    viewModel.shouldShowFavoritesOnly = true
    return BookmarksView()
        .environmentObject(viewModel) // ← це обовʼязково!
}



