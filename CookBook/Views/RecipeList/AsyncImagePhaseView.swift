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
    AsyncImagePhaseView(url: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixabay.com%2Fimages%2Fsearch%2Fnature%2F&psig=AOvVaw0KOvIQ0p5wxZBiV6Okh_eD&ust=1744956958854000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCLD5jq-13owDFQAAAAAdAAAAABAE", width: 100, height: 100)
}
