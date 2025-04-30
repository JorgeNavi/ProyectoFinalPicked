//
//  RegisterView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 8/4/25.
//

import SwiftUI

/// A view that allows users to choose whether to register as a restaurant or a consumer.
struct RegisterView: View {
    @Environment(AppStateVM.self) private var appState
    
    var body: some View {
        VStack {
            
            // App logo
            Image(.logotipo)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
            
            // Title
            Text("Are you a restaurant owner or a consumer?")
                .foregroundStyle(.white)
                .font(.title.bold())
                .multilineTextAlignment(.center)
            
            VStack(spacing: 10) {
                
                // Navigation link to restaurant registration
                NavigationLink {
                    RestaurantRegisterView(appState: appState)
                } label: {
                    Text("Restaurant")
                        .font(.system(size: 22).bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(.secondaryColor)
                        .clipShape(.buttonBorder)
                }
                
                // Navigation link to consumer registration
                NavigationLink {
                    ConsumerRegisterView(appState: appState)
                } label: {
                    Text("Consumer")
                        .font(.system(size: 22).bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(.secondaryColor)
                        .clipShape(.buttonBorder)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryColor)
    }
}

#Preview {
    RegisterView()
        .environment(AppStateVM())
}
