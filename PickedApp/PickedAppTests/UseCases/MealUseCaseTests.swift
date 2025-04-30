import XCTest
@testable import PickedApp

final class MealUseCaseTests: XCTestCase {

    func testFetchMyMealsSuccess() async throws {

        let useCase = MealUseCase(repo: MealRepositorySuccessMock())

        let meals = try await useCase.fetchMyMeals()

        XCTAssertEqual(meals.count, 2)
        XCTAssertEqual(meals.first?.name, "Pizza Margherita")
    }

    func testCreateMealSuccess() async throws {

        let useCase = MealUseCase(repo: MealRepositorySuccessMock())

        let request = MealCreateRequest(
            name: "Paella",
            info: "Traditional Spanish rice dish",
            units: 15,
            price: 20.0,
            type: "mediterranean",
            photo: nil
        )

        let meal = try await useCase.createMeal(requestData: request)

        XCTAssertEqual(meal.name, request.name)
        XCTAssertEqual(meal.info, request.info)
        XCTAssertEqual(meal.units, request.units)
        XCTAssertEqual(meal.price, request.price)
    }

    func testFetchMyMealsFailure() async {

        let useCase = MealUseCase(repo: MealRepositoryFailureMock())

        do {
            try await useCase.fetchMyMeals()
            XCTFail("Expected error not thrown")
        } catch let error as PKError {
            XCTAssertEqual(error, PKError.errorFromApi(statusCode: 500))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testCreateMealFailure() async {
        let useCase = MealUseCase(repo: MealRepositoryFailureMock())

        let request = MealCreateRequest(
            name: "Paella",
            info: "Traditional Spanish rice dish",
            units: 15,
            price: 20.0,
            type: "mediterranean",
            photo: nil
        )

        do {
            try await useCase.createMeal(requestData: request)
            XCTFail("Expected error not thrown")
        } catch let error as PKError {
            XCTAssertEqual(error, PKError.badUrl)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
