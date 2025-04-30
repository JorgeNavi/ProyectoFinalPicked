import Foundation

protocol MealUseCaseProtocol {
    var repo: MealRepositoryProtocol { get set }
    func fetchMyMeals() async throws -> [Meal]
    func createMeal(requestData: MealCreateRequest) async throws -> Meal
}

//MARK: Usecase de Meals
final class MealUseCase: MealUseCaseProtocol {
    var repo: MealRepositoryProtocol

    init(repo: MealRepositoryProtocol = DefaultMealRepository()) {
        self.repo = repo
    }

    func fetchMyMeals() async throws -> [Meal] {
        return try await repo.fetchMyMeals()
    }
    
    func createMeal(requestData: MealCreateRequest) async throws -> Meal {
        try await repo.createMeal(requestData: requestData)
    }
}

//MARK: Mock para MealUseCaseProtocol
final class MealUseCaseSuccessMock: MealUseCaseProtocol {
    
    var repo: MealRepositoryProtocol

    init(repo: MealRepositoryProtocol = MealRepositorySuccessMock()) {
        self.repo = repo
    }

    func fetchMyMeals() async throws -> [Meal] {
        try await repo.fetchMyMeals()
    }

    func createMeal(requestData: MealCreateRequest) async throws -> Meal {
        try await repo.createMeal(requestData: requestData)
    }
}

//MARK: Mock de fallo para MealUseCaseProtocol
final class MealUseCaseFailureMock: MealUseCaseProtocol {
    
    var repo: MealRepositoryProtocol

    init(repo: MealRepositoryProtocol = MealRepositoryFailureMock()) {
        self.repo = repo
    }

    func fetchMyMeals() async throws -> [Meal] {
        try await repo.fetchMyMeals()
    }

    func createMeal(requestData: MealCreateRequest) async throws -> Meal {
        try await repo.createMeal(requestData: requestData)
    }
}
