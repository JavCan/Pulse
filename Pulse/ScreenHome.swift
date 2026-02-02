import SwiftUI

struct ScreenHome: View {
    
    @State private var selectedTab: TabItem = .home
    @State private var isExpanding = false // Controla la expansión
    @State private var showRelaxationScreen = false
    
    // Configuración para el texto curvo
    let curvedText = "Feeling overwhelmed?"
    let radius: Double = 165
    
    var body: some View {
        ZStack {
            // Fondo base
            Color.Cream
                .ignoresSafeArea()
            
            VStack {
                // Affirmation Card
                VStack(spacing: 20) {
                    Text("Today's Affirmation")
                        .font(Font.custom("Comfortaa", size: 18).weight(.bold))
                        .foregroundColor(.Clay)
                    
                    Text("I am more than my circumstances dictate.")
                        .font(Font.custom("Comfortaa", size: 16))
                        .foregroundColor(.Clay)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .padding(.horizontal, 20)
                .background(Color.PalidSand.opacity(0.8))
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .opacity(isExpanding ? 0 : 1) // Se desvanece al expandir
                
                Spacer()
                
                // Panic Attack button Section
                ZStack {
                    // Líneas punteadas exteriores (desaparecen al expandir)
                    Group {
                        Circle()
                            .trim(from: 0.345, to: 0.629)
                            .stroke(Color.Clay, style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [10,10]))
                            .rotationEffect(.degrees(-10))
                        
                        Circle()
                            .trim(from: 0.345, to: 0.629)
                            .stroke(Color.Clay, style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [10,10]))
                            .rotationEffect(.degrees(200))
                    }
                    .frame(width: 330, height: 330)
                    .opacity(isExpanding ? 0 : 1)
                    
                    // --- TEXTO CURVO ---
                    ZStack {
                        ForEach(Array(curvedText.enumerated()), id: \.offset) { index, letter in
                            Text(String(letter))
                                .font(Font.custom("Comfortaa", size: 26).weight(.light))
                                .foregroundColor(.Clay)
                                .offset(y: -radius)
                                .rotationEffect(letterRotation(index: index))
                        }
                    }
                    .rotationEffect(.degrees(4))
                    .opacity(isExpanding ? 0 : 1)
                    
                    // CÍRCULO AZUL (EL QUE SE EXPANDE)
                    Circle()
                        .fill(Color.GlaciarBlue)
                        .frame(width: 257, height: 257)
                    // Cuando isExpanding es true, escala 15 veces su tamaño para cubrir toda la pantalla
                        .scaleEffect(isExpanding ? 15 : 1)
                        .animation(.easeInOut(duration: 2), value: isExpanding)
                        .zIndex(isExpanding ? 10 : 0) // Se pone encima de todo al crecer
                    
                    // CÍRCULO VERDE (EL BOTÓN)
                    Circle()
                        .fill(Color.SalviaGreen)
                        .frame(width: 222, height: 222)
                        .opacity(isExpanding ? 0 : 1) // <--- Se desvanece
                        .scaleEffect(isExpanding ? 0.8 : 1) // Pequeño efecto de encogimiento al desaparecer
                        .zIndex(isExpanding ? 11 : 1)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                isExpanding = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.none) { // .none elimina cualquier transición extra
                                    showRelaxationScreen = true
                                }
                            }
                        }
                }
                
                // Elementos inferiores
                Group {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 40, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.Clay)
                        .padding(.top, 0)
                    
                    Text("Press me!")
                        .padding(.top, 15)
                        .font(Font.custom("Comfortaa", size: 26).weight(.bold))
                        .foregroundColor(.Clay)
                }
                .opacity(isExpanding ? 0 : 1)
                
                Spacer().frame(height: 80)
                
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 8)
                    .opacity(isExpanding ? 0 : 1)
            }
            
            if showRelaxationScreen {
                ScreenRelaxation(onDismiss: {
                    // Al cerrar, reiniciamos ambos estados
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showRelaxationScreen = false
                        isExpanding = false
                    }
                })
                .transition(.opacity) // Un desvanecimiento suave al regresar
                .zIndex(20)
                .ignoresSafeArea()
            }
        }
        // Esto permite que el círculo ignore los bordes de la pantalla al crecer
        .ignoresSafeArea(isExpanding ? .all : [])
        
        
    }
    
    // Función para calcular la rotación de cada letra (ya la tenías)
    private func letterRotation(index: Int) -> Angle {
        let letterSpacing: Double = 6.7
        let totalLetters = Double(curvedText.count)
        let startAngle = -(totalLetters * letterSpacing) / 2
        return .degrees(startAngle + (Double(index) * letterSpacing))
    }
}

#Preview {
    ScreenHome()
}
