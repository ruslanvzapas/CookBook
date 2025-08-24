//
//  TagLabelView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 17.04.2025.
//

import SwiftUI

struct TagLabelView: View {
    let title: String
    let color: Color
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            //.fontWeight(.medium)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        //.background(color.opacity(0.2))
            .foregroundColor(Color("gray-700"))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("gray-500"), lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


#Preview {
    TagLabelView(title: "Vegan", color: .blue)
}
