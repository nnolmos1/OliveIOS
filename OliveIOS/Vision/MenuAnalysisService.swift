//
//  MenuAnalysisService.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/20/26.
//

import Foundation
import FirebaseAILogic

final class MenuAnalysisService {

    // MARK: - Gemini model

    private let model: GenerativeModel

    init() {
        let menuItemSchema = Schema.object(
            properties: [
                "name": Schema.string(),
                "tag": Schema.string(),
                "explanation": Schema.string()
            ]
        )

        let resultSchema = Schema.object(
            properties: [
                "safe": Schema.array(items: menuItemSchema),
                "caution": Schema.array(items: menuItemSchema),
                "avoid": Schema.array(items: menuItemSchema)
            ]
        )

        let generationConfig = GenerationConfig(
            temperature: 0.2,
            maxOutputTokens: 4096,
            responseMIMEType: "application/json",
            responseSchema: resultSchema
        )

        let systemInstruction = ModelContent(
            role: "system",
            parts: [
                TextPart("""
                You analyze restaurant menu text for a user's dietary needs.

                Put every recognizable menu item into exactly one category:

                safe:
                Items that appear reasonably compatible with the user's
                conditions and allergies.

                caution:
                Items that may need portion control, substitutions,
                ingredient confirmation, or removal of sauces and dressings.

                avoid:
                Items that clearly contain a stated allergen or strongly
                conflict with the user's stated dietary restrictions.

                Rules:
                - Only include items found in the supplied menu.
                - Do not invent menu items or ingredients.
                - Keep explanations brief and practical.
                - Clearly mention uncertainty when ingredients are unknown.
                - Never guarantee that an item is allergen-free.
                - Recommend checking with restaurant staff when appropriate.
                - This is general information, not medical advice.
                """)
            ]
        )

        model = FirebaseAI
            .firebaseAI(backend: .googleAI())
            .generativeModel(
                modelName: "gemini-3.5-flash",
                generationConfig: generationConfig,
                systemInstruction: systemInstruction
            )
    }

    // MARK: - Analyze menu

    func analyze(
        menuText: String,
        conditions: [String] = [
            "Type 2 Diabetes",
            "Hypertension"
        ],
        allergies: [String] = [
            "Peanuts"
        ]
    ) async throws -> MenuAnalysisResult {

        let cleanedMenuText = menuText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedMenuText.isEmpty else {
            throw MenuAnalysisError.emptyMenuText
        }

        let prompt = """
        Analyze this restaurant menu.

        Health conditions:
        \(formattedList(conditions))

        Allergies:
        \(formattedList(allergies))

        Menu text:
        ---
        \(cleanedMenuText)
        ---

        Return every recognizable menu item in exactly one of these arrays:

        - safe
        - caution
        - avoid

        Each item must contain:
        - name
        - tag
        - explanation

        Use short tags such as:
        - Balanced
        - High carb
        - High sodium
        - Allergen
        - Ask staff
        - Portion size
        """

        let response = try await model.generateContent(prompt)

        guard let responseText = response.text,
              !responseText.trimmingCharacters(
                in: .whitespacesAndNewlines
              ).isEmpty else {
            throw MenuAnalysisError.emptyResponse
        }

        guard let responseData = responseText.data(using: .utf8) else {
            throw MenuAnalysisError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(
                MenuAnalysisResult.self,
                from: responseData
            )
        } catch {
            print("Gemini response:")
            print(responseText)
            print("Decoding error:")
            print(error)

            throw MenuAnalysisError.decodingFailed(error)
        }
    }

    // MARK: - Helpers

    private func formattedList(_ values: [String]) -> String {
        guard !values.isEmpty else {
            return "None provided"
        }

        return values
            .map { "- \($0)" }
            .joined(separator: "\n")
    }
}

// MARK: - Errors

enum MenuAnalysisError: LocalizedError {

    case emptyMenuText
    case emptyResponse
    case invalidResponse
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .emptyMenuText:
            return "No readable menu text was found."

        case .emptyResponse:
            return "Gemini did not return a menu analysis."

        case .invalidResponse:
            return "Gemini returned an unreadable response."

        case .decodingFailed:
            return "The menu analysis could not be understood."
        }
    }
}
