//
//  LoadingView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 14/4/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
                .padding()
            
            Text("Loading...")
                .foregroundStyle(.white)
                .opacity(isAnimating ? 0 : 1)
                .animation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryColor)
    }
}

#Preview {
    LoadingView()
}
