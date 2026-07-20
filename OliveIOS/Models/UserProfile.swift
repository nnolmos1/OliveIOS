import Foundation

struct UserProfile: Codable {

    var fullName = ""

    var birthday = Date()

    var email = ""

    var phoneNumber = ""

    var conditions: Set<MedicalCondition> = []

    var allergies: Set<FoodAllergy> = []

    var dietaryPreferences: Set<DietaryPreference> = []

    var goal: UserGoal?

    var hasGrantedLocationPermission = false

    var hasGrantedCameraPermission = false
}
