//
//  ScreenHome.swift
//  Pulse
//
//  Created by Javier Canella Ramos on 18/01/26.
//

import SwiftUI

struct ScreenHome: View {
    
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        ZStack{
            
            Color.Cream
                .ignoresSafeArea()
            VStack{
                
                // Afirmation Card
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
                
                
                Spacer()
                
                // Panick Attack button
                ZStack{
                    
                    Circle()
                        .trim(from: 0.345, to: 0.629)
                        .stroke(
                            Color.Clay,
                            style: StrokeStyle(
                                lineWidth: 2,
                                lineCap: .round,
                                dash: [6, 6]
                            )
                        )
                        .frame(width: 330, height: 330)
                    
                    Circle()
                        .trim(from: 0.345, to: 0.629)
                        .stroke(
                            Color.Clay,
                            style: StrokeStyle(
                                lineWidth: 2,
                                lineCap: .round,
                                dash: [6, 6]
                            )
                        )
                        .frame(width: 330, height: 330)
                        .rotationEffect(.degrees(190))
                    
                    
                    Circle()
                        .fill(Color.GlaciarBlue)
                        .frame(width: 257, height: 257)
                    
                    Circle()
                        .fill(Color.SalviaGreen)
                        .frame(width: 222, height: 222)
                    
                }
                
                Image(systemName: "arrow.up")
                    .font(.system(size: 40, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.Clay)
                    .padding(.top, 0)
                
                Text("Press me!")
                    .padding(.top, 15)
                    .font(Font.custom("Comfortaa", size: 26).weight(.bold))
                    .foregroundColor(.Clay)
                
                Spacer().frame(height: 80)
                
                CustomTabBar(selectedTab: $selectedTab)
                                .padding(.bottom, 8)
            }
        }
    }
}


#Preview {
    ScreenHome()
}
