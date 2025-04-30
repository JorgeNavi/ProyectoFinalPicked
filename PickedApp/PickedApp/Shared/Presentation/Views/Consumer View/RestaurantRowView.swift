//
//  RestaurantRowView.swift
//  PickedApp
//
//  Created by Kevin Heredia on 18/4/25.
//

import SwiftUI

struct RestaurantRowView: View {
    let restaurant: RestaurantModel

    var body: some View {
        ZStack(alignment: .bottom) { // El ZStack alineará los elementos al fondo
            // Imagen de fondo
            AsyncImage(url: restaurant.photoRestaurant) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170, height: 170)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .frame(width: 170, height: 170)
                    .background(Color.gray)
            }

            // Degradado negro de abajo hacia arriba
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 60) // Degradado en la parte inferior
            .frame(maxWidth: .infinity)

            // Texto sobre el degradado
            Text(restaurant.name)
                .font(.callout.bold())
                .foregroundColor(.white)
                .padding([.leading, .bottom], 8) // Alineado a la izquierda y hacia abajo
                .frame(maxWidth: .infinity, alignment: .leading) // Alinea el texto a la izquierda
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .frame(width: 170, height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 10)) // Bordes redondeados
        .shadow(radius: 4)
    }
}

#Preview {
    RestaurantRowView(
        restaurant: RestaurantModel(
            id: UUID().uuidString,
            name: "Restaurante San Pedrito",
            info: "Comida tipica",
            address: "Av. Amazonas",
            zipCode: "120042",
            city: "Quito",
            country: "Ecuador",
            photo: "example.jpg",
            latitude: 0.0,
            longitude: 0.0,
            createdAt: "",
            updatedAt: "",
            user: Editor(id: "")
        )
    )
}


