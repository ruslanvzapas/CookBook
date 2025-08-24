//
//  FavoritesView.swift
//  CookBook
//
//  Created by Ruslan Vavulskyi-Zapasnyk on 06.02.2025.
//

/*import SwiftUI
import FirebaseAuth

// MARK: - Row View
struct SectionRowView: View {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: Color

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 28, weight: .regular))
                .scaledToFit()
                .frame(width: 48, height: 48)
                .padding(12)
                .background(iconColor)
                .foregroundColor(.white)
                .cornerRadius(12)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                    .padding(.bottom, 1)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 6)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
    }
}

// MARK: - Favorites View
struct FavoritesView: View {
    @StateObject private var listViewModel: RecipeListViewViewModel

    // Використовуємо uid, якщо він доступний, або "" для Previews
    init(userId: String? = nil) {
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        _listViewModel = StateObject(wrappedValue: RecipeListViewViewModel(userId: uid))
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        NavigationLink(destination: BookmarksView().environmentObject(listViewModel)) {
                            SectionRowView(
                                title: "Bookmarks",
                                subtitle: "1 Recipe",
                                iconName: "heart.fill",
                                iconColor: Color("brown-500")
                            )
                        }
                        Divider()

                        NavigationLink(destination: CreatedRecipesView(userId: listViewModel.userId)) {
                            SectionRowView(
                                title: "Created recipes",
                                subtitle: "1 Recipes",
                                iconName: "pencil.circle.fill",
                                iconColor: Color("brown-500")
                            )
                        }
                        Divider()

                        NavigationLink(destination: Text("Photo Recipes Detail")) {
                            SectionRowView(
                                title: "Photo Recipes",
                                subtitle: "4 item",
                                iconName: "photo.on.rectangle.angled",
                                iconColor: Color("brown-500")
                            )
                        }
                        Divider()

                        NavigationLink(destination: Text("Recently viewed Detail")) {
                            SectionRowView(
                                title: "Recently viewed",
                                subtitle: "3 Recipes",
                                iconName: "clock.fill",
                                iconColor: Color("brown-500")
                            )
                        }
                    }
                }
            }
            .navigationTitle("My Recipes")
        }
        .environmentObject(listViewModel)
    }
}

// MARK: - Preview
#Preview {
    FavoritesView(userId: "preview_user_id")
}
*/

import SwiftUI
import FirebaseAuth

// MARK: - Palette (підігнано під скрін)
private enum Palette {
    static let brandRed    = Color(red: 0.63, green: 0.12, blue: 0.12)

    static let cardPinkBG  = Color(red: 1.00, green: 0.95, blue: 0.95)
    static let cardPinkTag = Color(red: 1.00, green: 0.88, blue: 0.92)

    static let cardBeigeBG = Color(red: 0.96, green: 0.94, blue: 0.88)
    static let cardBeigeTag = Color(red: 0.94, green: 0.90, blue: 0.78)

    static let cardBlueBG  = Color(red: 0.90, green: 0.96, blue: 0.97)
    static let cardBlueTag = Color(red: 0.84, green: 0.94, blue: 0.97)

    static let cardGreenBG = Color(red: 0.91, green: 0.96, blue: 0.91)
    static let cardGreenTag = Color(red: 0.85, green: 0.93, blue: 0.85)

    static let goldInk     = Color(red: 0.69, green: 0.54, blue: 0.11)
    static let tealInk     = Color(red: 0.12, green: 0.55, blue: 0.64)
    static let greenInk    = Color(red: 0.20, green: 0.52, blue: 0.20)
}

// MARK: - Search Bar (лупа + плейсхолдер + мікрофон)
private struct SearchBar: View {
    @Binding var text: String
    var onMic: () -> Void = {}

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.systemGray6))

            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Search BUO", text: $text)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)

                Button(action: onMic) {
                    Image(systemName: "mic.fill")
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
            }
            .padding(.horizontal, 14)
        }
        .frame(height: 44)
    }
}

// MARK: - Category Tile
private struct CategoryTile: View {
    let title: String
    let countLabel: String
    let cardColor: Color
    let tagColor: Color
    let iconName: String
    let iconColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(cardColor)

                Image(systemName: iconName)
                    .font(.system(size: 44, weight: .regular))
                    .foregroundColor(iconColor)
            }
            .frame(height: 220)
            .overlay(alignment: .topLeading) {
                Text(countLabel)
                    .font(.caption2)
                    .foregroundColor(.primary.opacity(0.7))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule(style: .continuous).fill(tagColor)
                    )
                    .padding(10)
            }

            Text(title)
                .font(.body)
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
    }
}

// MARK: - Favorites (My Recipes) Screen
struct FavoritesView: View {
    @StateObject private var listViewModel: RecipeListViewViewModel
    @State private var searchText = ""

    init(userId: String? = nil) {
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        _listViewModel = StateObject(wrappedValue: RecipeListViewViewModel(userId: uid))
    }

    private let columns = [GridItem(.flexible(), spacing: 16),
                           GridItem(.flexible(), spacing: 16)]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {

                    // Search + Filters
                    HStack(spacing: 12) {
                        SearchBar(text: $searchText)
                        Button {
                            // open filters
                        } label: {
                            ZStack {
                                Circle().fill(Palette.brandRed)
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .frame(width: 44, height: 44)
                            .shadow(color: Palette.brandRed.opacity(0.25), radius: 6, y: 2)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 6)

                    // Grid
                    LazyVGrid(columns: columns, spacing: 18) {
                        // Bookmarks
                        NavigationLink {
                            BookmarksView()
                                .environmentObject(listViewModel)
                        } label: {
                            CategoryTile(
                                title: "Bookmarks",
                                countLabel: "15 recipes",
                                cardColor: Palette.cardPinkBG,
                                tagColor: Palette.cardPinkTag,
                                iconName: "heart.fill",
                                iconColor: Palette.brandRed
                            )
                        }

                        // My Recipes
                        NavigationLink {
                            CreatedRecipesView(userId: listViewModel.userId)
                        } label: {
                            CategoryTile(
                                title: "My Recipes",
                                countLabel: "2 recipes",
                                cardColor: Palette.cardBeigeBG,
                                tagColor: Palette.cardBeigeTag,
                                iconName: "fork.knife.circle.fill", // близько до пательні
                                iconColor: Palette.goldInk
                            )
                        }

                        // My Collections
                        NavigationLink {
                            Text("My Collections")
                                .font(.title3)
                                .padding()
                        } label: {
                            CategoryTile(
                                title: "My Collections",
                                countLabel: "2 collections",
                                cardColor: Palette.cardBlueBG,
                                tagColor: Palette.cardBlueTag,
                                iconName: "book.closed.fill",
                                iconColor: Palette.tealInk
                            )
                        }

                        // Photo Recipes
                        NavigationLink {
                            Text("Photo Recipes")
                                .font(.title3)
                                .foregroundStyle(Color.black)
                                .padding()
                        } label: {
                            CategoryTile(
                                title: "Photo Recipes",
                                countLabel: "2 recipes",
                                cardColor: Palette.cardGreenBG,
                                tagColor: Palette.cardGreenTag,
                                iconName: "photo.on.rectangle",
                                iconColor: Palette.greenInk
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("My Recipes")
            .navigationBarTitleDisplayMode(.inline)
        }
        .environmentObject(listViewModel)
    }
}

// MARK: - Preview
#Preview {
    FavoritesView(userId: "preview_user_id")
}

