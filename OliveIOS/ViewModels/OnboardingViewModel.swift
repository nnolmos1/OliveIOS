//
//  OnboardingViewModel.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import Foundation
import SwiftUI
import Combine

final class OnboardingViewModel: ObservableObject {

    @Published var userProfile = UserProfile()

    // MARK: - Conditions

    func toggleCondition(_ condition: MedicalCondition) {

        if userProfile.conditions.contains(condition) {
            userProfile.conditions.remove(condition)
        } else {
            userProfile.conditions.insert(condition)
        }
    }

    func hasCondition(_ condition: MedicalCondition) -> Bool {
        userProfile.conditions.contains(condition)
    }

    // MARK: - Allergies

    func toggleAllergy(_ allergy: FoodAllergy) {

        if userProfile.allergies.contains(allergy) {
            userProfile.allergies.remove(allergy)
        } else {
            userProfile.allergies.insert(allergy)
        }
    }

    func hasAllergy(_ allergy: FoodAllergy) -> Bool {
        userProfile.allergies.contains(allergy)
    }

    // MARK: - Dietary Preferences

    func togglePreference(_ preference: DietaryPreference) {

        if userProfile.dietaryPreferences.contains(preference) {
            userProfile.dietaryPreferences.remove(preference)
        } else {
            userProfile.dietaryPreferences.insert(preference)
        }
    }

    func hasPreference(_ preference: DietaryPreference) -> Bool {
        userProfile.dietaryPreferences.contains(preference)
    }

    // MARK: - Goal

    func setGoal(_ goal: UserGoal) {
        userProfile.goal = goal
    }

    func hasGoal(_ goal: UserGoal) -> Bool {
        userProfile.goal == goal
    }
    
    // MARK: - Permissions
    func setLocationPermission(_ granted: Bool) {
        userProfile.hasGrantedLocationPermission = granted
    }

    func setCameraPermission(_ granted: Bool) {
        userProfile.hasGrantedCameraPermission = granted
    }
}
