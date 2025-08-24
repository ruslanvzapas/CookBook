//
//  OverviewView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 02.02.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct OverviewView: View {
    let userId: String
    @State private var searchText = ""
    @State private var selectedTab = 0
    @State private var selectedCategory: RecipeCategory? = nil
    @StateObject private var viewModel: RecipeListViewViewModel

        init(userId: String) {
            self.userId = userId
            _viewModel = StateObject(wrappedValue: RecipeListViewViewModel(userId: userId))
        }
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    header
                    searchBar
                    carousel
                    topCategories
                    RecipeListG(viewModel: viewModel)
                }
                .padding(.horizontal)
                .padding(.bottom) 
            }
        }
    }
    
    private var header: some View {
        HStack {
            HStack(spacing: 12) {
                Rectangle()
                    .frame(width: 46, height: 46)
                    .cornerRadius(100)
                    .foregroundStyle(Color.gray)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello, User!")
                        .fontWeight(.medium)
                        .font(.system(size: 16))

                    Text("Let’s start cooking!")
                        .fontWeight(.regular)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.gray)
                }
            }
            Spacer()
            Button {
                //
            } label: {
                Image(systemName: "bell.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 19, weight: .medium))
                    .frame(width: 46, height: 46)
                    .background(Color("grey-100"))
                    .cornerRadius(100)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("brown-500"))
                    .padding(.leading, 10)

                TextField("Search BUO®", text: $searchText)
                    .padding(.vertical, 10)
            }
            .background(Color("grey-100"))
            .cornerRadius(10)

            Button {
                //
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(.white)
                    .font(.system(size: 19, weight: .medium))
                    .frame(width: 46, height: 46)
                    .background(Color("brown-500"))
                    .cornerRadius(12)
            }
        }
    }

    private var carousel: some View {
        TabView(selection: $selectedTab) {
            ForEach(0..<3) { index in
                VStack {
                    Image("Variant3")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 152)
                        .clipped()
                        .cornerRadius(12)
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 152)
        .clipShape(RoundedRectangle(cornerRadius: 12)) // якщо треба обрізку
    }

    private var topCategories: some View {
        VStack(alignment: .leading) {
            Text("Top Categories")
                .fontWeight(.semibold)
                .font(.system(size: 20))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(RecipeCategory.allCases) { category in
                        Text(category.rawValue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .foregroundColor(selectedCategory == category ? .white : .black)
                            .background(selectedCategory == category ? Color("brown-500") : Color.clear)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color("grey-100"), lineWidth: 1.5)
                            )
                            .onTapGesture {
                                selectedCategory = category 
                            }
                    }
                }
            }
        }
    }
}




#Preview {
    OverviewView(userId: "JbVXZ5lI8XQR30TCdBBMDCMk1Td2")
}
