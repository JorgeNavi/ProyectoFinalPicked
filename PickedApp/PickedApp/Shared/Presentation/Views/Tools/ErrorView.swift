//
//  ErrorView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 14/4/25.
//

import SwiftUI

struct ErrorView: View {
    @Environment(AppStateVM.self) var appState
    
    private var textError: String
    
    init(textError: String) {
        self.textError = textError
    }
    var body: some View {
        ZStack{
            Image("")
                .resizable()
                .background(Color.red)
            VStack {
                
                //Imagen error
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .padding(.bottom)
                
                //Texto
                Text("OOOOPS!")
                    .font(.title)
                    .padding(.bottom, 50)
                    .foregroundStyle(.white)
                    .bold()
                Text("Something went wrong")
                    .foregroundStyle(.white)
                Text("Please try again.")
                    .foregroundStyle(.white)
                    .padding(.bottom, 50)
                
                //Boton Regresar
                Button {
                    appState.status = .login
                } label: {
                    Text("Go back")
                        .font(.headline)
                        .foregroundStyle(.red)
                        .frame(width: 200, height: 50)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 7, x: 7, y: 7)
                }
            } //fin vstack
        } //fin zstack
    }
}

#Preview {
    ErrorView(textError: "Error de preview")
        .environment(AppStateVM())
}
