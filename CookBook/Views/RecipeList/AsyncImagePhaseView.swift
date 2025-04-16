//
//  AsyncImagePhaseView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 17.04.2025.
//

import SwiftUI

struct AsyncImagePhaseView: View {
    let url: String?
    let width: CGFloat?
    let height: CGFloat?
    
    var body: some View {
        AsyncImage(url: URL(string: url ?? "")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
            } else if phase.error != nil {
                Text("There was an error loading the image.")
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    AsyncImagePhaseView(url: "https://example.com/image.jpg", width: 100, height: 100)
}
