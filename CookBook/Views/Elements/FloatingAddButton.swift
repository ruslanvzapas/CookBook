//
//  FloatingAddButton.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 27.05.2025.
//

import SwiftUI

import SwiftUI

struct FloatingAddButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.green) // Або інший колір, який вам подобається
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}
