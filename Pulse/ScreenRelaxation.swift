import SwiftUI

struct ScreenRelaxation: View {
    var onDismiss: () -> Void
    
    // Estados de animación y control
    @State private var circleScale: CGFloat = 1.0
    @State private var currentText: String = ""
    @State private var phraseIndex = 0
    @State private var viewOpacity: Double = 0.0
    
    // Estados para los contadores
    @State private var countdown = 5 // Contador inicial de preparación
    @State private var isCountingDown = true
    @State private var secondsRemaining = 0 // Segundos de la fase actual
    @State private var timer: Timer? = nil // Timer para controlar los segundos

    let phrases = [
        "This is uncomfortable, not dangerous.",
        "You are safe right now.",
        "Nothing bad is happening.",
        "You’re not in danger."
    ]

    var body: some View {
        ZStack {
            Color.GlaciarBlue
                .ignoresSafeArea()
            
            // Botón de Cerrar
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        timer?.invalidate() // Detener timer al salir
                        onDismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 30)
                            .padding(.top, 60)
                    }
                }
                Spacer()
            }
            
            VStack(spacing: 40) {
                if isCountingDown {
                    // --- PANTALLA DE PREPARACIÓN (5s) ---
                    VStack(spacing: 20) {
                        Text("Prepare to breathe")
                            .font(Font.custom("Comfortaa", size: 22).weight(.medium))
                        
                        Text("\(countdown)")
                            .font(Font.custom("Comfortaa", size: 80).weight(.bold))
                    }
                    .foregroundColor(.white)
                    .transition(.opacity)
                } else {
                    // --- PANTALLA DE RESPIRACIÓN ACTIVA ---
                    VStack(spacing: 40) {
                        // Frases con transición de fade
                        Text(phrases[phraseIndex])
                            .font(Font.custom("Comfortaa", size: 20).weight(.medium))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .frame(height: 80)
                            .id(phraseIndex)
                            .transition(.opacity.animation(.easeInOut(duration: 1.0)))
                        
                        // Círculo visual (Vacío por dentro)
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 2)
                                .frame(width: 280, height: 280)
                            
                            Text("\(secondsRemaining)")
                                .font(Font.custom("Comfortaa", size: 50).weight(.bold))
                                .foregroundColor(.white.opacity(0.8))
                                .monospacedDigit() // Evita que el texto salte al cambiar de número
                            
                            Circle()
                                .stroke(Color.white, lineWidth: 15)
                                .frame(width: 200, height: 200)
                                .scaleEffect(circleScale)
                        }
                        
                        // --- ETIQUETAS Y CONTADOR DEBAJO DEL CÍRCULO ---
                        VStack(spacing: 5) {
                            Text(currentText)
                                .font(Font.custom("Comfortaa", size: 28).weight(.bold))
                                .foregroundColor(.white)
                                .id(currentText) // Fade suave al cambiar de palabra
                                .transition(.opacity.animation(.easeInOut))
                            
                        }.padding(.top, 20)
                    }
                    .transition(.opacity)
                }
            }
        }
        .opacity(viewOpacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                viewOpacity = 1.0
            }
            startInitialCountdown()
        }
    }

    // MARK: - Lógica de Tiempos
    
    func startInitialCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if countdown > 1 {
                countdown -= 1
            } else {
                t.invalidate()
                withAnimation { isCountingDown = false }
                runInhalePhase()
            }
        }
    }

    func runInhalePhase() {
        currentText = "Inhale"
        secondsRemaining = 4
        withAnimation(.easeInOut(duration: 4)) {
            circleScale = 1.4
        }
        startPhaseTimer(duration: 4) { runHoldPhase() }
    }

    func runHoldPhase() {
        currentText = "Hold"
        secondsRemaining = 4
        startPhaseTimer(duration: 4) { runExhalePhase() }
    }

    func runExhalePhase() {
        currentText = "Exhale"
        secondsRemaining = 6
        withAnimation(.easeInOut(duration: 6)) {
            circleScale = 1.0
        }
        startPhaseTimer(duration: 6) {
            // Al terminar exhalar, cambiar frase y reiniciar
            withAnimation(.easeInOut(duration: 1.0)) {
                phraseIndex = (phraseIndex + 1) % phrases.count
            }
            runInhalePhase()
        }
    }

    // Helper para manejar el conteo de segundos de cada fase
    func startPhaseTimer(duration: Int, completion: @escaping () -> Void) {
        timer?.invalidate()
        var timeLeft = duration
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if timeLeft > 1 {
                timeLeft -= 1
                secondsRemaining = timeLeft
            } else {
                t.invalidate()
                completion()
            }
        }
    }
}

#Preview{
    ScreenRelaxation(onDismiss: {})
}
