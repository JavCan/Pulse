import SwiftUI

struct ScreenRelaxation: View {
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.GlaciarBlue
                .ignoresSafeArea()
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        onDismiss() // close action
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 30)
                            .padding(.top, 70)
                    }
                }
                Spacer()
            }
            
            VStack(spacing: 30) {
                Text("Breathe deeply")
                    .font(Font.custom("Comfortaa", size: 28).weight(.bold))
                    .foregroundColor(.white)
                
                // Relaxing logic
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 20)
                    .frame(width: 200, height: 200)
            }
        }
    }
}

#Preview{
    ScreenRelaxation(onDismiss: {})
}
