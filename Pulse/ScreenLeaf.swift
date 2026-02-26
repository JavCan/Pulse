import SwiftUI

// MARK: - Article Data Model
struct ArticleData: Identifiable {
    let id: Int
    let title: String
    let cardSubtitle: String
    let imageName: String
    let thumbnailName: String
    let paragraphs: [String]
    let sources: [(label: String, url: String)]
}

let articlesData: [ArticleData] = [
    ArticleData(
        id: 1,
        title: "What is a Panic Attack and Why Does It Feel So Intense?",
        cardSubtitle: "I am more than my circumstances dictate.",
        imageName: "article_1",
        thumbnailName: "article_1_thumb",
        paragraphs: [
            "A panic attack is a sudden episode of intense fear or discomfort that peaks within minutes, often without any real danger or obvious trigger. Common symptoms include rapid heartbeat, sweating, shortness of breath, chest pain, dizziness, trembling, and a sense of impending doom or loss of control.",
            "It feels so intense because it activates the body's fight-or-flight response, flooding the system with adrenaline and stress hormones like cortisol via the sympathetic nervous system and HPA axis. This causes exaggerated physical reactions—such as a pounding heart and hyperventilation—even without a threat, mimicking a heart attack and amplifying terror through amygdala hyperactivity. Attacks typically last 5-30 minutes but can leave lingering exhaustion."
        ],
        sources: [
            ("Merriam-Webster", "https://www.merriam-webster.com/dictionary/panic%20attack"),
            ("Timothy Center", "https://timothycenter.com/what-does-a-panic-attack-feel-like-12-symptoms/")
        ]
    ),
    ArticleData(
        id: 2,
        title: "Why does this happen to me \"out of nowhere\" if I'm not stressed?",
        cardSubtitle: "I am more than my circumstances dictate.",
        imageName: "article_2",
        thumbnailName: "article_2_thumb",
        paragraphs: [
            "Panic attacks can strike without warning, even if you feel calm. They often seem to come \"out of nowhere\" because hidden triggers or body signals build up quietly.",
            "Your brain's fear center might misfire, spotting a false danger like a change in heartbeat or stomach flip. Past experiences, genes, or imbalances in brain chemicals can make this happen randomly, skipping obvious stress.",
            "Breathing shifts or caffeine can spark it too, turning a tiny sensation into full panic fast. These episodes peak quick but fade, showing your body just overreacted."
        ],
        sources: [
            ("Mayo Clinic", "https://www.mayoclinic.org/diseases-conditions/panic-attacks/symptoms-causes/syc-20376021"),
            ("Merriam-Webster", "https://www.merriam-webster.com/dictionary/panic%20attack"),
            ("Better Health", "https://www.betterhealth.vic.gov.au/health/conditionsandtreatments/panic-attack")
        ]
    ),
    ArticleData(
        id: 3,
        title: "What happens in my brain during a panic attack?",
        cardSubtitle: "I am more than my circumstances dictate.",
        imageName: "article_3",
        thumbnailName: "article_3_thumb",
        paragraphs: [
            "During a panic attack, your brain's fear center called the amygdala goes into overdrive, sounding a false alarm as if danger is near. It signals the release of stress hormones like adrenaline, ramping up your heart rate and breathing to prepare for \"fight or flight.\"",
            "This creates a feedback loop: the amygdala senses normal body changes—like a faster heartbeat—as threats, triggering more panic. The prefrontal cortex, which calms fear, gets overwhelmed and can't stop the surge, making everything feel out of control.",
            "Once the attack peaks in minutes, hormone levels drop, and calm returns as the brain resets."
        ],
        sources: [
            ("MindEase", "https://mindease.io/wellness-blog/panic-attack-neuroscience"),
            ("Timothy Center", "https://timothycenter.com/what-does-a-panic-attack-feel-like-12-symptoms/"),
            ("Merriam-Webster", "https://www.merriam-webster.com/dictionary/panic%20attack")
        ]
    )
]

// MARK: - Screen Leaf
struct ScreenLeaf: View {
    
    @Binding var selectedTab: TabItem
    @State private var selectedMood: Int? = nil
    var body: some View {
        NavigationStack {
            ZStack {
                Color.Cream
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 14) {
                            // MARK: - Articles Section
                            ForEach(articlesData) { article in
                                NavigationLink(destination: ArticleDetailView(article: article)) {
                                    ArticleCard(
                                        title: "\(article.title)",
                                        subtitle: article.cardSubtitle,
                                        thumbnailName: article.thumbnailName
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
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
                    .padding(.bottom, 100)
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
}

// MARK: - Article Detail View
struct ArticleDetailView: View {
    let article: ArticleData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.Cream
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title
                        Text(article.title)
                            
                            .font(Font.custom("Comfortaa", size: 22).weight(.bold))
                            .foregroundColor(.Clay)
                            .lineSpacing(4)
                        
                        // First paragraph
                        if article.paragraphs.count > 0 {
                            Text(article.paragraphs[0])
                                .font(Font.custom("Comfortaa", size: 14))
                                .foregroundColor(.Clay.opacity(0.85))
                                .lineSpacing(6)
                        }
                        
                        // Image
                        Image(article.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(20)
                        
                        // Remaining paragraphs
                        ForEach(Array(article.paragraphs.dropFirst().enumerated()), id: \.offset) { _, paragraph in
                            Text(paragraph)
                                .font(Font.custom("Comfortaa", size: 14))
                                .foregroundColor(.Clay.opacity(0.85))
                                .lineSpacing(6)
                        }
                        
                        // Sources
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sources")
                                .font(Font.custom("Comfortaa", size: 16).weight(.bold))
                                .foregroundColor(.Clay)
                            
                            ForEach(Array(article.sources.enumerated()), id: \.offset) { _, source in
                                Link(destination: URL(string: source.url)!) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "link")
                                            .font(.system(size: 12))
                                        Text(source.label)
                                            .font(Font.custom("Comfortaa", size: 13))
                                            .underline()
                                    }
                                    .foregroundColor(.SalviaGreen)
                                }
                            }
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.PalidSand.opacity(0.5))
                        .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                    // Added top padding to avoid the dynamic island
                    .padding(.top, 80)
                    .padding(.bottom, 100) // Extra padding for floating button
                }
            }
            
            // Floating Close Button
            VStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Color.red.opacity(0.5))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Article Card
struct ArticleCard: View {
    let title: String
    let subtitle: String
    let thumbnailName: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(thumbnailName)
                .resizable()
                .scaledToFill()
                .frame(width: 75, height: 75)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(Font.custom("Comfortaa", size: 12).weight(.bold))
                    .foregroundColor(.Clay)
                
                Text(subtitle)
                    .font(Font.custom("Comfortaa", size: 12))
                    .foregroundColor(.Clay.opacity(0.8))
                    .lineLimit(2)
            }
            
            
            Image(systemName: "chevron.right")
                    .foregroundColor(.Clay.opacity(0.6))
                    .font(.system(size: 14, weight: .semibold))
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
