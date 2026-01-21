//
//  ScreenHome.swift
//  Pulse
//
//  Created by Javier Canella Ramos on 18/01/26.
//

import SwiftUI

struct ScreenHome: View {
    var body: some View {
        ZStack{
            
            Color.Cream
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Today's Affirmation")
                    .font(.system(size: 28, weight: .medium, design: .serif))
                    .foregroundColor(.Clay)
                
                Text("I am more than my circumstances dictate.")
                    .font(.system(size: 22, weight: .regular, design: .serif))
                    .foregroundColor(.Clay)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(40)
            .background(Color.PalidSand)
            .cornerRadius(30)
            .padding(.horizontal, 20)
            Spacer()
            
        }
    }
}


#Preview {
    ScreenHome()
}
