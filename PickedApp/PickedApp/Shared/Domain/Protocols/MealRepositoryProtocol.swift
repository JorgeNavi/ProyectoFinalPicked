

protocol MealRepositoryProtocol {
    func fetchMyMeals() async throws -> [Meal]
    func createMeal(requestData: MealCreateRequest) async throws -> Meal
}
