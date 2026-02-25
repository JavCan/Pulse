import SwiftUI

struct ScreenLeaf: View {
    
    @Binding var selectedTab: TabItem
    @State private var selectedMood: Int? = nil
    
    var body: some View {
        ZStack {
            Color.Cream
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        // MARK: - Articles Section
                        ForEach(1...3, id: \.self) { index in
                            ArticleCard(
                                title: "Article \(index)",
                                subtitle: "I am more than my circumstances dictate."
                            )
                        }
                        
                        // MARK: - Nervous System Care Section
                        VStack(spacing: 14) {
                            Text("Nervous System Care")
                                .font(Font.custom("Comfortaa", size: 24).weight(.medium))
                                .foregroundColor(.Clay)
                                .padding(.top, 20)
                            
                            // How are you feeling today?
                            VStack(alignment: .leading, spacing: 12) {
                                Text("How are you feeling today?")
                                    .font(Font.custom("Comfortaa", size: 15).weight(.medium))
                                    .foregroundColor(.Clay)
                                
                                HStack(spacing: 12) {
                                    ForEach(1...5, id: \.self) { mood in
                                        Image("\(mood)")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 48, height: 48)
                                            .opacity(selectedMood == nil || selectedMood == mood ? 1.0 : 0.4)
                                            .scaleEffect(selectedMood == mood ? 1.15 : 1.0)
                                            .animation(.easeInOut(duration: 0.2), value: selectedMood)
                                            .onTapGesture {
                                                withAnimation {
                                                    selectedMood = (selectedMood == mood) ? nil : mood
                                                }
                                            }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(18)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(20)
                            .padding(.horizontal, 14)
                            
                            // Calm Sounds & Guided Practices
                            HStack(spacing: 12) {
                                SmallCard(title: "Calm Sounds")
                                SmallCard(title: "Guided Practices")
                            }
                            .padding(.horizontal, 14)
                            .padding(.bottom, 15)
                        }
                        .background(Color.GlaciarBlue.opacity(0.5))
                        .cornerRadius(30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 100) // Space for tab bar
                }
                
                Spacer(minLength: 0)
            }
            
            // Tab Bar
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 8)
            }
        }
    }
}

// MARK: - Article Card
struct ArticleCard: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 14) {
            // Placeholder image
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.PalidSand)
                .frame(width: 75, height: 75)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(Font.custom("Comfortaa", size: 17).weight(.bold))
                    .foregroundColor(.Clay)
                
                Text(subtitle)
                    .font(Font.custom("Comfortaa", size: 13))
                    .foregroundColor(.Clay.opacity(0.8))
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.PalidSand.opacity(0.5))
        .cornerRadius(22)
    }
}

// MARK: - Small Card
struct SmallCard: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Font.custom("Comfortaa", size: 14).weight(.medium))
                .foregroundColor(.Clay)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 80)
        .padding(16)
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
    }
}

#Preview {
    ScreenLeaf(selectedTab: .constant(.breathe))
}
