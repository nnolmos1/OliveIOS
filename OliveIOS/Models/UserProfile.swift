import Foundation

struct UserProfile {

    var conditions: Set<MedicalCondition> = []

    var allergies: Set<FoodAllergy> = []

    var dietaryPreferences: Set<DietaryPreference> = []

    var goal: UserGoal?

    var hasGrantedLocationPermission = false

    var hasGrantedCameraPermission = false
}
