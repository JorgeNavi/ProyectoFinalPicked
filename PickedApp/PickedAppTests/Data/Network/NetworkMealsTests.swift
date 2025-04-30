import XCTest
@testable import PickedApp

final class NetworkMealsTests: XCTestCase {
    
    func testGetMyMealsSuccess() async throws {
        let network = NetworkMealSuccessMock()
        let result = try await network.fetchMyMeals()
        XCTAssertNotNil(result)
    }
    
    func testCreateMealSuccess() async throws {
        let network = NetworkMealSuccessMock()
        let request = MealCreateRequest(
            name: "Sushi",
            info: "Fresh salmon sushi rolls",
            units: 20,
            price: 18.5,
            type: "asian",
            photo: nil
        )
        let result = try await network.createMeal(requestData: request)
        XCTAssertEqual(result.name, request.name)
        XCTAssertEqual(result.info, request.info)
        XCTAssertEqual(result.units, request.units)
        XCTAssertEqual(result.price, request.price)
        XCTAssertNotNil(result.id)
    }
    
    func testGetMyMealsFailure() async {
        let network = NetworkMealFailureMock()
        do {
            try await network.fetchMyMeals()
            XCTFail("Expected error was not thrown")
        } catch let error as PKError {
            XCTAssertEqual(error, PKError.errorFromApi(statusCode: 500))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testCreateMealFailure() async {
        let network = NetworkMealFailureMock()
        let request = MealCreateRequest(
            name: "Sushi",
            info: "Fresh salmon sushi rolls",
            units: 20,
            price: 18.5,
            type: "asian",
            photo: nil
        )
        do {
            try await network.createMeal(requestData: request)
            XCTFail("Expected error was not thrown")
        } catch let error as PKError {
            XCTAssertEqual(error, PKError.badUrl)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testFetchMyMealsRealNetworkSuccess() async throws {
        let mockMeals = [
            Meal(id: UUID(), name: "Test Meal", info: "Test Info", units: 3, price: 10.0, photo: "/test.jpg")
        ]
        let mockData = try! JSONEncoder().encode(mockMeals)
        
        // Configurar URLProtocolMock
        URLProtocolMock.stubResponseData = mockData
        URLProtocolMock.statusCode = 200
        URLProtocolMock.error = nil
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: config)
        
        let network = NetworkMeal(session: mockSession)
        let result = try await network.fetchMyMeals()
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Test Meal")
    }
    
    func testFetchMyMealsRealNetworkFailure() async {
        URLProtocolMock.stubResponseData = nil
        URLProtocolMock.statusCode = 500
        URLProtocolMock.error = nil
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: config)
        
        let network = NetworkMeal(session: mockSession)
        
        do {
            try await network.fetchMyMeals()
            XCTFail("Expected error was not thrown")
        } catch let error as PKError {
            XCTAssertEqual(error, PKError.errorFromApi(statusCode: 500))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
