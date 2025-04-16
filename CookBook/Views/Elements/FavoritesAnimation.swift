import SwiftUI

struct FavoritesAnimation: View {
    /// View Properties
    @State private var beatAnimation: Bool = true
    @State private var showPusles: Bool = true
    @State private var pulsedHearts: [HeartParticle] = []
    @State private var heartBeat: Int = 85

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                ZStack {
                    if showPusles {
                        TimelineView(.animation(minimumInterval: 0.7, paused: false)) { timeline in
                            ZStack {
                                ForEach(pulsedHearts) { _ in
                                    PulseHeartView()
                                }
                            }
                            .onChange(of: timeline.date) { oldValue, newValue in
                                if beatAnimation {
                                    addPulsedHeart()
                                }
                            }
                        }
                    }
                    
                    Image(systemName: "suit.heart.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(.heart.gradient)
                        .symbolEffect(.bounce, options: !beatAnimation ? .default : .repeating.speed(1), value: beatAnimation)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .padding(.top, 40)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text("You have no favorite recipes yet.")
                        .font(.title3)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        // Add action for exploring or adding recipes
                    }) {
                        Text("Explore Recipes")
                            .font(.body)
                            .foregroundColor(.blue)
                            .underline()
                    }
                }
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .padding()
            .navigationTitle("Favorites Recipes")
        }
    }
    
    func addPulsedHeart() {
        let pulsedHeart = HeartParticle()
        pulsedHearts.append(pulsedHeart)
        
        /// Removing After the pulse animation was Finished
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            pulsedHearts.removeAll(where: { $0.id == pulsedHeart.id })
            
            if pulsedHearts.isEmpty {
                showPusles = false
            }
        }
    }
}

/// Pulsed Heart Animation View
struct PulseHeartView: View {
    @State private var startAnimation: Bool = false
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(.system(size: 100))
            .foregroundStyle(.heart)
            .background(content: {
                Image(systemName: "suit.heart.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.white)
                    .blur(radius: 5, opaque: false)
                    .scaleEffect(startAnimation ? 1.1 : 0)
                    .animation(.linear(duration: 1.5), value: startAnimation)
            })
            .scaleEffect(startAnimation ? 4 : 1)
            .opacity(startAnimation ? 0 : 0.7)
            .onAppear(perform: {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            })
    }
}

#Preview {
    FavoritesAnimation()
}
