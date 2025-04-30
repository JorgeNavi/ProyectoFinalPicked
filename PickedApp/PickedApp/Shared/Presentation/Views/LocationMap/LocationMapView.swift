import SwiftUI
import MapKit

//Vista que muestra el mapa con la ubicación del usuario y los restaurantes cercanos.
struct LocationMapView: View {
    
    @State var viewModel: GetNearbyRestaurantViewModel //ViewModel que maneja la lógica del mapa.
    
    //Inicializa la vista con un ViewModel opcional.
    init(viewModel: GetNearbyRestaurantViewModel = GetNearbyRestaurantViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack{
            Map(position: $viewModel.cameraPosition) {
                
                UserAnnotation()
                
                ForEach(viewModel.restaurantsNearby) { restaurant in
                    Annotation(restaurant.name, coordinate: restaurant.coordinate) {
                        Button {
                            viewModel.selectRestaurant(restaurant)
                        } label: {
                            RestaurantAnnotationView(restaurant: restaurant)
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    try await viewModel.loadData()
                }
            }
            .sheet(item: $viewModel.selectedRestaurant) { restaurant in
                RestaurantSelectedMapDetailView(restaurant: restaurant)
                    .presentationDetents([.medium])
            }
            .mapControls {
                MapCompass()
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await viewModel.centerOnUserLocation()
                        }
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.primaryColor)
                                    .frame(width: 32, height: 32)
                            )
                    }
                }
            }
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//Vista previa para SwiftUI.
#Preview {
    LocationMapView()
}
