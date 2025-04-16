//
//  CBButton.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 11.01.2025.
//

import SwiftUI

struct CBButton: View {
    let title: String
    let backgroundColor: Color
    let height: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(backgroundColor)
                Text(title)
                    .foregroundStyle(Color.white)
            }
        }
        .frame(height: height)
        .padding()
    }
}

#Preview {
    CBButton(
        title: "Title",
        backgroundColor: Color.blue,
        height: 50.0) {
        //action
    }
}
