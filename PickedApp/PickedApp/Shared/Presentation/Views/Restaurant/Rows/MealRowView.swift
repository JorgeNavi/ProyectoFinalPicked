import SwiftUI

//MARK: Vista para casilla de plato
struct MealRowView: View {
    
    let meal: Meal 

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            //Imagen del plato cargada de forma asíncrona desde la URL
            AsyncImage(url: URL(string: "http://localhost:8080\(meal.photo)")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
            } placeholder: {
                //Placeholder mientras se carga la imagen
                ProgressView()
                    .frame(width: 80, height: 80)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    //Nombre del plato
                    Text(meal.name)
                        .font(.headline)
                        .lineLimit(1)

                    Spacer()

                    //Precio del plato
                    Text(String(format: "$%.2f", meal.price))
                        .font(.headline)
                        .foregroundColor(.orange)
                }

                //Unidades disponibles del plato
                Text("Units: \(meal.units.map { String($0) } ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

//MARK: Vista previa
#Preview {
    MealRowView(meal: Meal(
        id: UUID(),
        name: "Example Meal",
        info: "Delicious meal with fresh ingredients.",
        units: 5,
        price: 9.99,
        photo: "/images/example.jpg"
    ))
    .padding()
    .background(Color.gray.opacity(0.1))
}
