//
//  FavoritesView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 06.02.2025.
//

import SwiftUI

struct FavoritesView: View {
    @State private var searchText: String = ""
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                    TextField("Search recipes", text: $searchText)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(height: 45)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("GrayColor"))
                }
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    FavoritesView()
}
