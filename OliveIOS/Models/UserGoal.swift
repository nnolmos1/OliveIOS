import Foundation

enum UserGoal: String, CaseIterable, Codable, Identifiable, Hashable {

    case avoidTriggers = "Avoid foods that trigger my condition"
    case safeRestaurants = "Find safe restaurant options"
    case understandNutrition = "Understand nutrition information"
    case improveHealth = "Improve overall health"
    case manageAllergies = "Manage my allergies"

    var id: String { rawValue }

    var icon: String {

        switch self {

        case .avoidTriggers:
            return "shield.fill"

        case .safeRestaurants:
            return "fork.knife"

        case .understandNutrition:
            return "brain.head.profile"

        case .improveHealth:
            return "heart.fill"

        case .manageAllergies:
            return "exclamationmark.shield.fill"
        }
    }
}
