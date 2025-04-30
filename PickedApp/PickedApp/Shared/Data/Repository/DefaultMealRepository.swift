import Foundation

//MARK: Repository para Meals
final class DefaultMealRepository: MealRepositoryProtocol {

    private var network: NetworkMealProtocol

    init(network: NetworkMealProtocol = NetworkMeal()) {
        self.network = network
    }

    func fetchMyMeals() async throws -> [Meal] {
        try await network.fetchMyMeals()
    }
    
    func createMeal(requestData: MealCreateRequest) async throws -> Meal {
        try await network.createMeal(requestData: requestData)
    }
}

//MARK: Mock para MealRepositoryProtocol
final class MealRepositorySuccessMock: MealRepositoryProtocol {
    
    private var network: NetworkMealProtocol

    init(network: NetworkMealProtocol = NetworkMealSuccessMock()) {
        self.network = network
    }

    func fetchMyMeals() async throws -> [Meal] {
        try await network.fetchMyMeals()
    }

    func createMeal(requestData: MealCreateRequest) async throws -> Meal {
        try await network.createMeal(requestData: requestData)
    }
}

//MARK: Mock de fallo para MealRepositoryProtocol
final class MealRepositoryFailureMock: MealRepositoryProtocol {
    
    private var network: NetworkMealProtocol

    init(network: NetworkMealProtocol = NetworkMealFailureMock()) {
        self.network = network
    }

    func fetchMyMeals() async throws -> [Meal] {
        try await network.fetchMyMeals()
    }

    func createMeal(requestData: MealCreateRequest) async throws -> Meal {
        try await network.createMeal(requestData: requestData)
    }
}
