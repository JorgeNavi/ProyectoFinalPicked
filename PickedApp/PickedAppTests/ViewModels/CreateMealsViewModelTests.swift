
import XCTest
@testable import PickedApp

final class CreateMealsViewModelTests: XCTestCase {

    func testCreateMealSuccess() async throws {
        let appState = AppStateVM()
        
        let viewModel = CreateMealViewModel(useCase: MealUseCaseSuccessMock(), appState: appState)

        let name = "Test Meal"
        let info = "Delicious test meal"
        let price = "9.99"
        let units = "5"
        let type = "italian"
        let photoData = "FakeImageData".data(using: .utf8)

        let result = try await viewModel.createMeal(
            name: name,
            info: info,
            price: price,
            units: units,
            type: type,
            photo: photoData
        )

        XCTAssertNotNil(result)
        XCTAssertEqual(viewModel.successMessage, "Dish '\(name)' was successfully created!")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showSuccessAlert)
    }

    
    func testCreateMealFailure() async {
        let appState = AppStateVM()
        let viewModel = CreateMealViewModel(useCase: MealUseCaseFailureMock(), appState: appState)

        let name = "Test Meal"
        let info = "Invalid test meal"
        let price = "invalid"
        let units = "invalid"
        let type = "mexican"
        let photoData = "FakeImageData".data(using: .utf8)

        let result = try? await viewModel.createMeal(
            name: name,
            info: info,
            price: price,
            units: units,
            type: type,
            photo: photoData
        )

        XCTAssertFalse(result ?? true)
        XCTAssertEqual(viewModel.errorMessage, "Price and Units must be valid numbers.")
        XCTAssertFalse(viewModel.showSuccessAlert)
        XCTAssertEqual(appState.status, .none)
    }

    func testCreateMealFailureFromUseCase() async throws {
        let appState = AppStateVM()
        let viewModel = CreateMealViewModel(useCase: MealUseCaseFailureMock(), appState: appState)

        let name = "Test Meal"
        let info = "Delicious test meal"
        let price = "9.99"
        let units = "5"
        let type = "italian"
        let photoData = "FakeImageData".data(using: .utf8)

        let result = try await viewModel.createMeal(
            name: name,
            info: info,
            price: price,
            units: units,
            type: type,
            photo: photoData
        )

        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.errorMessage, "Incorrect form")
        XCTAssertFalse(viewModel.showSuccessAlert)
        XCTAssertEqual(appState.status, .none)
    }
}
