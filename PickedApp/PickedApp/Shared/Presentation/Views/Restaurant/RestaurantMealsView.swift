import SwiftUI

//MARK: Vista de los platos del restaurante
struct RestaurantMealsView: View {
    
    @Environment(AppStateVM.self) var appState
    @State var viewModel: RestaurantMealsViewModel
    @State private var isShowingCreateMeal = false

    init(viewModel: RestaurantMealsViewModel = RestaurantMealsViewModel(appState: AppStateVM())) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            VStack {
                //Encabezado con título y botón para añadir plato
                HStack {
                    Text("My Dishes")
                        .font(.title)
                        .bold()

                    Spacer()

                    //Botón que activa la navegación al formulario
                    Button(action: {
                        isShowingCreateMeal = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.orange)
                    }
                }
                .padding()

                //Mostrar el estado actual de la app
                switch appState.status {
                case .loading:
                    ProgressView("loading meals...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .error(let errorMsg):
                    Text("Error: \(errorMsg)")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                default:
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.meals) { meal in
                                MealRowView(meal: meal)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadMyMeals()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task{
                            await appState.closeSessionUser()
                        }
                    }) {
                        Image(systemName: "power.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
            }
            //Navegación al formulario con NavigationLink
            .navigationDestination(isPresented: $isShowingCreateMeal) {
                CreateMealView()
            }
        }
    }
}

//MARK: Vista previa
#Preview {
    let sampleMeals: [Meal] = (1...9).map { i in
        Meal(
            id: UUID(),
            name: "Sample Dish \(i)",
            info: "Delicious and tasty meal number \(i)",
            units: 5,
            price: Float(i) * 3.5,
            photo: "/images/sample\(i).jpg"
        )
    }

    let mockViewModel = RestaurantMealsViewModel(appState: AppStateVM())
    mockViewModel.meals = sampleMeals

    return RestaurantMealsView(viewModel: mockViewModel)
        .environment(AppStateVM())
}
