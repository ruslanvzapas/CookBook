//
//  OverviewView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 02.02.2025.
//

import SwiftUI

struct OverviewView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                // Поле для пошуку
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        

                    TextField("Search recipes...", text: $searchText)
                        .padding(10)
                }
                .padding(10)
                .frame(height: 44.0)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Слайдер карток
                TabView(selection: $selectedTab) {
                    ForEach(0..<5) { index in // 5 карток для прикладу
                        VStack {
                            Color.blue // тут буде картинка чи контент
                                .frame(height: 200)
                                .cornerRadius(16)
                                .overlay(
                                    Text("Card \(index + 1)")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                )
                        }
                        .padding(.horizontal)
                        .tag(index)
                    }
                }
                .frame(height: 200) // Висота для слайдера
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Включаємо точечки
                .padding(.vertical)
                
                Spacer()
            }
            .navigationTitle("Overview")
        }
    }
}

#Preview {
    OverviewView()
}
