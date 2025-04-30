//
//  IconTextFieldView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 8/4/25.
//

import SwiftUI

struct IconTextFieldView: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType
    
    var body: some View {
        
        //MARK: Custom TextField
        HStack {
            Image(systemName: iconName)
                .foregroundStyle(.secondaryColor)
            TextField(placeholder, text: $text)
                .padding(.vertical, 7)
                .keyboardType(keyboardType)

        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
        .clipShape(.buttonBorder)
    }
}

#Preview {
    IconTextFieldView(
        iconName: "person",
        placeholder: "Username",
        text: .constant(
            "example@example.com"
        ),
        keyboardType: .emailAddress
    )
        
}
