import Foundation

enum FoodAllergy: String, CaseIterable, Identifiable, Hashable {

    case peanuts = "Peanuts"
    case treeNuts = "Tree Nuts"
    case milk = "Milk"
    case eggs = "Eggs"
    case soy = "Soy"
    case fish = "Fish"
    case shellfish = "Shellfish"
    case wheat = "Wheat"
    case sesame = "Sesame"

    var id: String { rawValue }

    var icon: String {

        switch self {

        case .peanuts:
            return "exclamationmark.triangle.fill"

        case .treeNuts:
            return "leaf.fill"

        case .milk:
            return "drop.fill"

        case .eggs:
            return "circle.fill"

        case .soy:
            return "square.fill"

        case .fish:
            return "fish.fill"

        case .shellfish:
            return "tortoise.fill"

        case .wheat:
            return "ear.fill"

        case .sesame:
            return "sparkles"
        }
    }
}
