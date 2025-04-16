//
//  TabBarView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 02.02.2025.
//

import SwiftUI

struct TabBarView: View {
    @Binding var activeTab: TabItem
    let userId: String

    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18, *) {
                TabView(selection: $activeTab) {
                    ForEach(TabItem.allCases, id: \.self) { tab in
                        tab.view(userId: userId)
                            .tag(tab)
                            .toolbarVisibility(.hidden, for: .tabBar)
                    }
                }
            } else {
                TabView(selection: $activeTab) {
                    ForEach(TabItem.allCases, id: \.self) { tab in
                        tab.view(userId: userId)
                            .tag(tab)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
            }
            InteractiveTabBar(activeTab: $activeTab)
        }
    }
}

struct InteractiveTabBar: View {
    @Binding var activeTab: TabItem
    @Namespace private var animation
    @State private var tabButtonLocations: [CGRect] = Array(repeating: .zero, count: TabItem.allCases.count)
        @State private var activeDraggingTab: TabItem?

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabButton(tab)
            }
        }
        .frame(height: 64)
        .padding(8)
        .background {
            Capsule()
                .fill(Color(.black).shadow(.drop(color: .primary.opacity(0.1), radius: 5)))
        }
        .coordinateSpace(.named("TABBAR"))
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
    }
    
    @ViewBuilder
    func TabButton(_ tab: TabItem) -> some View {
        let isActive = (activeDraggingTab ?? activeTab) == tab

        VStack(spacing: 6) {
            Image(systemName: tab.symbolImage)
                //.resizable()
                //.scaledToFit()
                //.frame(width: 25.0, height: 25.0)
                .font(.system(size: 22, weight: .medium))
                .symbolVariant(isActive ? .fill : .none)
                .foregroundStyle(isActive ? Color("brown-500") : .white)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            if isActive {
                Capsule()
                    .fill(Color.white)
                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
            }
        }
        .onTapGesture {
            withAnimation(.snappy) {
                activeTab = tab
            }
        }
    }
}

enum TabItem: String, CaseIterable {
    case main = "Main"
    case search = "Search"
    case allRecipes = "Recipes"
    case favorites = "Favorites"
    case profile = "Profile"
    //case favorites = "Favorites"

    var symbolImage: String {
        switch self {
        case .main: return "house"
        case .search: return "magnifyingglass"
        case .allRecipes: return "book"
        case .favorites: return "cart"
        case .profile: return "person"
      //  case .favorites: return "star.fill"
        }
    }

    @ViewBuilder
    func view(userId: String) -> some View {
        switch self {
        case .main:
            RecipeListView(userId: userId)
        case .search:
            FavoritesView()
        case .allRecipes:
            ProductListView(userId: userId)
        case .favorites:
            FavoritesView()
        case .profile:
            ProfileView()
        }
    }
}

#Preview {
    @Previewable @State var activeTab: TabItem = .main
    return TabBarView(activeTab: $activeTab, userId: "B1xpwSkHdocXfhVqixwHyNZdQdh2")
}
