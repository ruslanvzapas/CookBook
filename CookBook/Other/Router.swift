//
//  Router.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 28.05.2025.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var deepLinkedRecipeID: String?

    func handle(url: URL) {
        guard url.scheme == "cookbook",
              url.host == "recipe",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let id = components.queryItems?.first(where: { $0.name == "id" })?.value
        else { return }

        deepLinkedRecipeID = id
    }
}

