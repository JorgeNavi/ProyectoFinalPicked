//
//  IconSecureTextView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 9/4/25.
//

import SwiftUI

struct IconSecureFieldView: View {
    let icon: String
    let placeholder: String
    @Binding var password: String
    
    @State private var isPasswordVisible = false
    
    var body: some View {
        
        //MARK: Custom SecureField
        
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondaryColor)
            
            // Mostrar TextField o SecureField dependiendo del estado
            Group {
                if isPasswordVisible {
                    TextField(placeholder, text: $password)
                } else {
                    SecureField(placeholder, text: $password)
                }
            }
            .frame(height: 24)
            .padding(.vertical, 7)
            
            // Botón para mostrar/ocultar contraseña
            Button {
                isPasswordVisible.toggle()
            } label: {
                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundStyle(.secondaryColor)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
        .clipShape(.buttonBorder)
    }
}

#Preview {
    IconSecureFieldView(icon: "lock.fill", placeholder: "Password", password: .constant("123456"))
        .preferredColorScheme(.dark)
}
