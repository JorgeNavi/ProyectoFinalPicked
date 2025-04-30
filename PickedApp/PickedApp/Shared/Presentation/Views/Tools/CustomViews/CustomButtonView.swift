//
//  CustomButtonView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 9/4/25.
//

import SwiftUI

struct CustomButtonView: View {
    var title: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        //MARK: Custom Button
        Button(action: action) {
            Text(title)
                .font(.system(size: 22).bold())
                .foregroundStyle(.white)
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity)
                .background(color)
                .clipShape(.buttonBorder)
        }
    }
}

#Preview {
    CustomButtonView(title: "Login", color: .primaryColor, action: {})
    
}
