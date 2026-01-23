//
//  ContentView.swift
//  Pulse
//
//  Created by Javier Canella Ramos on 18/01/26.
//

import SwiftUI


struct ContentView: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        VStack {
            CurvedText(text: "¡Hola Mundo Curvo!", radius: 100)
                .frame(width: 200, height: 200) // Define el tamaño del contenedor
            
            // Puedes centrarlo si lo deseas
                    
            CustomTabBar(selectedTab: $selectedTab)
                            .padding(.bottom, 8)
        }
    }
}

#Preview {
    ContentView()
}
