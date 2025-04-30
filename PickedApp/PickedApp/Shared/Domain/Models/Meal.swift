import Foundation

struct Meal: Codable, Identifiable {
    let id: UUID
    let name: String
    let info: String?
    let units: Int?
    let price: Float
    let photo: String
}
