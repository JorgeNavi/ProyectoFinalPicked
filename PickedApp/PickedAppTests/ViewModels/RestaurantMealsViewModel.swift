
import XCTest
@testable import PickedApp

final class RestaurantMealsViewModelTests: XCTestCase {
    
    
    func testLoadMyMealsSuccess() async {

        let appState = AppStateVM()
        
        let viewModel = RestaurantMealsViewModel(useCase: MealUseCaseSuccessMock(), appState: appState)

        await viewModel.loadMyMeals()

        XCTAssertEqual(viewModel.meals.count, 2)
        XCTAssertEqual(viewModel.meals.first?.name, "Pizza Margherita")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(appState.status, .loaded)
    }
    
    func testLoadMyMealsFailure() async {
        let appState = AppStateVM()
        let viewModel = RestaurantMealsViewModel(useCase: MealUseCaseFailureMock(), appState: appState)

        await viewModel.loadMyMeals()

        XCTAssertEqual(viewModel.meals.count, 0)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(appState.status, .error(error: viewModel.errorMessage ?? ""))
    }
}
