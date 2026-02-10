import SwiftUI

struct ScreenBodyReconnection: View {
    var onFinish: () -> Void
    var onClose: () -> Void
    @State private var currentStep = 0
    @State private var viewOpacity: Double = 0.0
    
    // Instrucciones de la Fase 3
    let steps = [
        "Press your feet gently into the floor.",
        "Relax your jaw. Let your tongue rest.",
        "Drop your shoulders."
    ]
    
    var body: some View {
        ZStack {
            // Usamos el nuevo color verde menta para esta fase
            Color.RelaxGreen
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white.opacity(0.6)) // Color white para contraste
                            .padding(.horizontal, 30)
                            .padding(.top, 60)
                    }
                }
                Spacer()
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                // Icono decorativo de calma
                Image(systemName: "figure.mindful.relaxing")
                    .font(.system(size: 60))
                    .foregroundColor(Color.white.opacity(0.6))
                    .padding(.bottom, 20)
                
                // Instrucción actual
                Text(steps[currentStep])
                    .font(Font.custom("Comfortaa", size: 28).weight(.medium))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .frame(height: 180)
                    .id(currentStep)
                    .transition(.opacity.animation(.easeInOut(duration: 0.8)))
                
                Spacer()
                
                // Botón para avanzar
                Button(action: nextStep) {
                    Text(currentStep < steps.count - 1 ? "Next" : "Continue")
                        .font(Font.custom("Comfortaa", size: 20).weight(.bold))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 60)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(30)
                }
                .padding(.bottom, 50)
            }
        }
        .opacity(viewOpacity)
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                viewOpacity = 1.0
            }
        }
    }
    
    func nextStep() {
        if currentStep < steps.count - 1 {
            withAnimation {
                currentStep += 1
            }
            // Feedback háptico suave
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } else {
            onFinish()
        }
    }
}
