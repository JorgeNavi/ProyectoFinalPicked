
import SwiftUI

struct RestaurantSelectedMapDetailView: View {
    @Environment(\.dismiss) var dismiss
    let restaurant: RestaurantModel
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: restaurant.photoRestaurant) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }
            
            Text(restaurant.name)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text(restaurant.info)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack {
                Image(systemName: "mappin.and.ellipse")
                Text(restaurant.address)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            CustomButtonView(title: "Close", color: .primaryColor) {
                dismiss()
            }
        }
        .padding()
    }
}

#Preview {
    RestaurantSelectedMapDetailView(restaurant: RestaurantModel(id: "", name: "", info: "", address: "", zipCode: "", city: "", country: "", photo: "", latitude: 0.0, longitude: 0.0, createdAt: "", updatedAt: "", user: Editor(id: "")))
}
