//
//  SplashView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 8/4/25.
//

import SwiftUI

struct SplashView: View {
    @Environment(AppStateVM.self) var appState
    
    var body: some View {
        ZStack { 
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryColor)
    }
}

#Preview {
    SplashView()
        .environment(AppStateVM())
}
