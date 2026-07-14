import Foundation

enum DietaryPreference: String, CaseIterable, Identifiable, Hashable {

    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case glutenFree = "Gluten Free"
    case dairyFree = "Dairy Free"
    case lowSodium = "Low Sodium"
    case lowCarb = "Low Carb"
    case halal = "Halal"
    case kosher = "Kosher"

    var id: String { rawValue }

    var icon: String {

        switch self {

        case .vegetarian:
            return "leaf.fill"

        case .vegan:
            return "leaf.circle.fill"

        case .glutenFree:
            return "checkmark.seal.fill"

        case .dairyFree:
            return "drop.triangle.fill"

        case .lowSodium:
            return "heart.fill"

        case .lowCarb:
            return "bolt.fill"

        case .halal:
            return "moon.stars.fill"

        case .kosher:
            return "star.fill"
        }
    }
}
