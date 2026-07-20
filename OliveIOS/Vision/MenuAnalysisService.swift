//
//  MenuAnalysisService.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/20/26.
//

import Foundation

final class MenuAnalysisService {

    func analyze(menuText: String) async throws -> MenuAnalysisResult {
        let cleanedText = menuText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedText.isEmpty else {
            throw MenuAnalysisError.emptyMenuText
        }

        // Temporary delay so the full app flow can be tested.
        try await Task.sleep(for: .milliseconds(800))

        // Temporary demo response.
        // Replace this with a request to your backend later.
        return MenuAnalysisResult(
            safe: [
                AnalyzedMenuItem(
                    name: "Grilled Salmon",
                    tag: "Balanced",
                    explanation: "A protein-focused option that may work well with vegetables and sauce on the side."
                ),
                AnalyzedMenuItem(
                    name: "Steamed Vegetables",
                    tag: "Lower carb",
                    explanation: "A vegetable side that is generally lower in carbohydrates. Ask for no added salt or butter when possible."
                )
            ],
            caution: [
                AnalyzedMenuItem(
                    name: "Chicken Alfredo",
                    tag: "High carb",
                    explanation: "The pasta and creamy sauce may be higher in carbohydrates, saturated fat, and sodium."
                ),
                AnalyzedMenuItem(
                    name: "Tomato Soup",
                    tag: "Sodium",
                    explanation: "Restaurant soups can contain a lot of sodium. Ask whether a lower-sodium option is available."
                )
            ],
            avoid: [
                AnalyzedMenuItem(
                    name: "Peanut Stir Fry",
                    tag: "Allergen",
                    explanation: "This item contains peanuts and should be avoided for a peanut allergy."
                )
            ]
        )
    }
}

enum MenuAnalysisError: LocalizedError {
    case emptyMenuText
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .emptyMenuText:
            return "No readable menu text was found. Try a clearer, closer photo."
        case .invalidResponse:
            return "The menu analysis response was invalid."
        }
    }
}
