//
//  ProductListItemsView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import SwiftUI

struct ProductListItemView: View {
    @StateObject var viewModel = ProductListItemViewViewModel()
    let item: ProductListItem
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.body)
                Text(item.quantity)
                    .font(.footnote)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            
            Spacer()
            
            Button {
                viewModel.toggleIsDone(item: item)
            } label: {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
            }
        }
    }
}

#Preview {
    ProductListItemView(item: .init(
        id: "123",
        title: "Test",
        quantity: "2 g",
        //dueDate: Date().timeIntervalSince1970,
        //createdDate: Date().timeIntervalSince1970,
        isDone: false
    ))
}
