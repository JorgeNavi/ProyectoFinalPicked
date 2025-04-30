
import SwiftUI

struct RestaurantAnnotationView: View {
    var restaurant: RestaurantModel
    
    var body: some View {
        VStack {
            Image(.locationMap)
                .foregroundColor(.red)
                .font(.title)
            Text(restaurant.name)
                .font(.caption)
                .fixedSize()
                .padding(4)
                .background(Color.white.opacity(0.8))
                .cornerRadius(5)
        }
    }
}

#Preview {
    RestaurantAnnotationView(
        restaurant: RestaurantModel(
            id: UUID().uuidString,
            name: "Restaurante 1",
            info: "Comida Típica",
            address: "Av. Amazonas",
            zipCode: "125760",
            city: "Quito",
            country: "Ecuador",
            photo: "photo",
            latitude: 0.0,
            longitude: 0.0,
            createdAt: "",
            updatedAt: "",
            user: Editor(id: "")
        )
    )
}
