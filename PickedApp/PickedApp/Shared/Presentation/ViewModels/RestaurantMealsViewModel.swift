import Foundation
import SwiftUI

//MARK: ViewModel de la pantalla de platos del restaurante
@Observable
final class RestaurantMealsViewModel {
    
    private var appState: AppStateVM
    var errorMessage: String?
    var meals: [Meal] = []

    @ObservationIgnored
    private let useCase: MealUseCaseProtocol

    init(useCase: MealUseCaseProtocol = MealUseCase(), appState: AppStateVM) {
        self.useCase = useCase
        self.appState = appState
    }

    //Método para cargar todos los platos del restaurante autenticado
    func loadMyMeals() async {
        appState.status = .loading
        errorMessage = nil

        do {
            //Intentar obtener los platos del restaurante
            meals = try await useCase.fetchMyMeals()
            appState.status = .loaded
        } catch {
            //Si ocurre un error, actualizar estado y mostrar mensaje
            errorMessage = error.localizedDescription
            appState.status = .error(error: error.localizedDescription)
        }
    }
}
