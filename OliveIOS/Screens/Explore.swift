//
//  Explore.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct Explore: View {

    @State private var profile = UserProfileStorage.load()
    @State private var searchText = ""

    private let restaurants = ExploreRestaurant.uicInnovationCenterRestaurants
    private let oliveGreen = OliveTheme.primaryGreen
    private let deepOlive = OliveTheme.deepOlive
    private let warmBackground = OliveTheme.warmBackground
    private let cardBackground = OliveTheme.cardBackground

    private var filteredRestaurants: [ExploreRestaurant] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        let rankedRestaurants = restaurants.sorted {
            $0.fitScore(for: profile) > $1.fitScore(for: profile)
        }

        guard !query.isEmpty else {
            return rankedRestaurants
        }

        return rankedRestaurants.filter { restaurant in
            restaurant.name.localizedCaseInsensitiveContains(query)
            || restaurant.cuisine.localizedCaseInsensitiveContains(query)
            || restaurant.tags.contains {
                $0.localizedCaseInsensitiveContains(query)
            }
            || restaurant.recommendedOptions.contains {
                $0.name.localizedCaseInsensitiveContains(query)
                || $0.summary.localizedCaseInsensitiveContains(query)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    headerSection
                    searchSection
                    recommendationSection
                }
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(warmBackground.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                profile = UserProfileStorage.load()
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "location.magnifyingglass")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 13)
                            .fill(oliveGreen)
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text("Explore Restaurants")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(deepOlive)

                    Text("Near UIC Innovation Center")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(deepOlive.opacity(0.72))
                }

                Spacer()
            }
        }
    }

    private var searchSection: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.secondary)

            TextField("Search restaurants or cuisines", text: $searchText)
                .font(.system(size: 14))

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(cardBackground)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(OliveTheme.subtleBorder, lineWidth: 1)
        }
    }


    private var recommendationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended Nearby")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(deepOlive)

            LazyVStack(spacing: 12) {
                ForEach(filteredRestaurants) { restaurant in
                    NavigationLink {
                        RestaurantDetailView(
                            restaurant: restaurant,
                            profile: profile
                        )
                    } label: {
                        restaurantCard(restaurant)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func restaurantCard(_ restaurant: ExploreRestaurant) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(spacing: 12) {
                Image(systemName: restaurant.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(oliveGreen)
                    .frame(width: 48, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(oliveGreen.opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(restaurant.name)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(deepOlive)

                    Text("\(restaurant.distance) mi - \(restaurant.cuisine)")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                fitBadge(score: restaurant.fitScore(for: profile))
            }

            Text(restaurant.profileSummary(for: profile))
                .font(.system(size: 13))
                .foregroundStyle(deepOlive.opacity(0.72))
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                ForEach(restaurant.tags.prefix(3), id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(deepOlive.opacity(0.78))
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.72))
                        )
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(cardBackground)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(OliveTheme.subtleBorder, lineWidth: 1)
        }
        .shadow(color: deepOlive.opacity(0.08), radius: 10, y: 5)
    }

    private func fitBadge(score: Int) -> some View {
        VStack(spacing: 2) {
            Text("\(score)")
                .font(.system(size: 15, weight: .bold))

            Text("fit")
                .font(.system(size: 10, weight: .semibold))
        }
        .foregroundStyle(.white)
        .frame(width: 46, height: 46)
        .background(
            Circle()
                .fill(oliveGreen)
        )
    }

}

private struct RestaurantDetailView: View {

    let restaurant: ExploreRestaurant
    let profile: UserProfile

    @State private var showAskOlive = false
    @State private var questionText = ""

    private let oliveGreen = OliveTheme.primaryGreen
    private let deepOlive = OliveTheme.deepOlive
    private let warmBackground = OliveTheme.warmBackground
    private let cardBackground = OliveTheme.cardBackground

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                heroSection
                overviewSection
                recommendedMenuSection
                askOliveButton
            }
            .padding(.horizontal, 18)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .background(warmBackground.ignoresSafeArea())
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAskOlive) {
            AskOliveRestaurantSheet(
                restaurant: restaurant,
                questionText: $questionText
            )
            .presentationDetents([.medium])
        }
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Image(systemName: restaurant.icon)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 58, height: 58)
                    .background(
                        RoundedRectangle(cornerRadius: 17)
                            .fill(oliveGreen)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(restaurant.name)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(deepOlive)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("\(restaurant.distance) mi - \(restaurant.cuisine)")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            Text(restaurant.longDescription)
                .font(.system(size: 14))
                .foregroundStyle(deepOlive.opacity(0.74))
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                ForEach(restaurant.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(deepOlive.opacity(0.78))
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.72))
                        )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(cardBackground)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(OliveTheme.subtleBorder, lineWidth: 1)
        }
    }

    private var overviewSection: some View {
        HStack(spacing: 10) {
            overviewMetric(
                value: "\(restaurant.fitScore)",
                label: "Profile Fit",
                systemImage: "leaf.fill"
            )

            overviewMetric(
                value: "\(restaurant.recommendedOptions.count)",
                label: "Top Picks",
                systemImage: "checkmark.seal.fill"
            )

            overviewMetric(
                value: restaurant.priceLevel,
                label: "Price",
                systemImage: "creditcard.fill"
            )
        }
    }

    private var recommendedMenuSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Safer Menu Options")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(deepOlive)

            ForEach(restaurant.recommendedOptions.sortedByFit(for: profile)) { option in
                menuOptionCard(option)
            }
        }
    }

    private var askOliveButton: some View {
        Button {
            showAskOlive = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 20, weight: .semibold))

                VStack(alignment: .leading, spacing: 3) {
                    Text("Ask Olive")
                        .font(.system(size: 16, weight: .bold))

                    Text("Ask a question about this restaurant")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white.opacity(0.78))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundStyle(.white)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(oliveGreen)
            )
        }
        .buttonStyle(.plain)
    }

    private func overviewMetric(
        value: String,
        label: String,
        systemImage: String
    ) -> some View {
        VStack(spacing: 7) {
            Image(systemName: systemImage)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(oliveGreen)

            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(deepOlive)

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 13)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(cardBackground)
        )
    }

    private func menuOptionCard(_ option: RestaurantMenuOption) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: option.level.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(option.level.tint)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(option.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(deepOlive)

                        Spacer()

                        Text(option.price)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }

                    Text(option.summary)
                        .font(.system(size: 13))
                        .foregroundStyle(deepOlive.opacity(0.72))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Text(option.reason(for: profile))
                .font(.system(size: 12))
                .foregroundStyle(deepOlive.opacity(0.72))
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(option.level.tint.opacity(0.12))
                )
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(cardBackground)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(OliveTheme.subtleBorder, lineWidth: 1)
        }
    }
}

private struct AskOliveRestaurantSheet: View {

    let restaurant: ExploreRestaurant
    @Binding var questionText: String

    private let oliveGreen = OliveTheme.primaryGreen
    private let deepOlive = OliveTheme.deepOlive

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Capsule()
                .fill(Color.secondary.opacity(0.34))
                .frame(width: 38, height: 5)
                .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 6) {
                Text("Ask Olive")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(deepOlive)

                Text("Ask about \(restaurant.name), menu ingredients, or safer substitutions.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            VStack(alignment: .leading, spacing: 10) {
                TextField("Example: Which entree is lowest in sodium?", text: $questionText)
                    .font(.system(size: 14))
                    .padding(13)
                    .background(
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color(.secondarySystemBackground))
                    )

                Button {
                } label: {
                    Text("Ask Question")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    questionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                    ? Color.gray
                                    : oliveGreen
                                )
                        )
                }
                .disabled(questionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Suggested questions")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(deepOlive)

                suggestedQuestion("Can I eat here with my profile?")
                suggestedQuestion("Which item should I avoid?")
                suggestedQuestion("What substitutions should I ask for?")
            }

            Spacer()
        }
        .padding(20)
    }

    private func suggestedQuestion(_ text: String) -> some View {
        Button {
            questionText = text
        } label: {
            HStack {
                Text(text)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(deepOlive)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
    }
}

private struct ExploreRestaurant: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let cuisine: String
    let distance: String
    let priceLevel: String
    let fitScore: Int
    let icon: String
    let tags: [String]
    let shortDescription: String
    let longDescription: String
    let recommendedOptions: [RestaurantMenuOption]
}

private struct RestaurantMenuOption: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: String
    let summary: String
    let personalizedReason: String
    let level: RecommendationLevel
    var supportsConditions: Set<MedicalCondition> = []
    var avoidsAllergies: Set<FoodAllergy> = []
    var supportsPreferences: Set<DietaryPreference> = []
    var supportsGoals: Set<UserGoal> = []
}

private enum RecommendationLevel: Hashable {
    case safe
    case caution

    var icon: String {
        switch self {
        case .safe:
            "checkmark.circle.fill"

        case .caution:
            "exclamationmark.circle.fill"
        }
    }

    var tint: Color {
        switch self {
        case .safe:
            OliveTheme.primaryGreen

        case .caution:
            Color(red: 0.67, green: 0.54, blue: 0.26)
        }
    }
}

private extension ExploreRestaurant {
    func fitScore(for profile: UserProfile) -> Int {
        let optionBoost = recommendedOptions
            .map { $0.fitScore(for: profile) }
            .max() ?? 0

        return min(99, fitScore + optionBoost)
    }

    func profileSummary(for profile: UserProfile) -> String {
        guard let topOption = recommendedOptions.sortedByFit(for: profile).first else {
            return shortDescription
        }

        let matches = topOption.matchingReasons(for: profile)

        guard !matches.isEmpty else {
            return shortDescription
        }

        return "\(topOption.name) stands out here: \(matches.joined(separator: " "))"
    }
}

private extension RestaurantMenuOption {
    func fitScore(for profile: UserProfile) -> Int {
        matchingReasons(for: profile).count * 3
    }

    func reason(for profile: UserProfile) -> String {
        let matches = matchingReasons(for: profile)

        guard !matches.isEmpty else {
            return personalizedReason
        }

        return "\(personalizedReason) Olive matched this to your profile because \(matches.joined(separator: " "))"
    }

    func matchingReasons(for profile: UserProfile) -> [String] {
        var reasons: [String] = []

        let conditionMatches = supportsConditions.intersection(profile.conditions)
        if !conditionMatches.isEmpty {
            reasons.append("it supports \(conditionMatches.sortedLabels).")
        }

        let allergyMatches = avoidsAllergies.intersection(profile.allergies)
        if !allergyMatches.isEmpty {
            reasons.append("it is easier to order around \(allergyMatches.sortedLabels).")
        }

        let preferenceMatches = supportsPreferences.intersection(profile.dietaryPreferences)
        if !preferenceMatches.isEmpty {
            reasons.append("it fits \(preferenceMatches.sortedLabels).")
        }

        if let goal = profile.goal, supportsGoals.contains(goal) {
            reasons.append("it helps with \(goal.rawValue.lowercased()).")
        }

        return reasons
    }
}

private extension Array where Element == RestaurantMenuOption {
    func sortedByFit(for profile: UserProfile) -> [RestaurantMenuOption] {
        sorted {
            $0.fitScore(for: profile) > $1.fitScore(for: profile)
        }
    }
}

private extension Set where Element: RawRepresentable, Element.RawValue == String {
    var sortedLabels: String {
        map(\.rawValue)
            .sorted()
            .joined(separator: ", ")
            .lowercased()
    }
}

private extension ExploreRestaurant {
    static let uicInnovationCenterRestaurants: [ExploreRestaurant] = [
        ExploreRestaurant(
            name: "Stax Cafe",
            cuisine: "Breakfast, Brunch",
            distance: "0.5",
            priceLevel: "$$",
            fitScore: 86,
            icon: "sunrise.fill",
            tags: ["High Protein", "Vegetarian", "Customizable"],
            shortDescription: "A nearby breakfast and brunch spot where eggs, oatmeal, and vegetable sides make profile-aware ordering easier.",
            longDescription: "Stax Cafe is a practical UIC-area option for breakfast and lunch because many plates can be built around eggs, vegetables, fruit, and simple sides. For allergies, ask the kitchen about shared griddles and cross-contact.",
            recommendedOptions: [
                RestaurantMenuOption(
                    name: "Veggie Egg White Omelet",
                    price: "Varies",
                    summary: "Egg whites with vegetables, fruit on the side, and toast skipped or kept small.",
                    personalizedReason: "Protein and vegetables make this a steady option. Ask for light salt and choose fruit instead of fried sides.",
                    level: .safe,
                    supportsConditions: [.diabetes, .hypertension, .cholesterol, .heartDisease],
                    avoidsAllergies: [.peanuts, .treeNuts, .fish, .shellfish],
                    supportsPreferences: [.vegetarian, .lowCarb, .lowSodium],
                    supportsGoals: [.safeRestaurants, .improveHealth, .understandNutrition]
                ),
                RestaurantMenuOption(
                    name: "Steel-Cut Oatmeal Bowl",
                    price: "Varies",
                    summary: "Oatmeal with berries or banana, nuts left off when needed, and sweetener on the side.",
                    personalizedReason: "A fiber-forward choice that can work well for cholesterol and blood sugar goals when toppings are controlled.",
                    level: .safe,
                    supportsConditions: [.diabetes, .cholesterol, .heartDisease, .ibs],
                    avoidsAllergies: [.eggs, .fish, .shellfish],
                    supportsPreferences: [.vegetarian, .dairyFree],
                    supportsGoals: [.improveHealth, .understandNutrition]
                ),
                RestaurantMenuOption(
                    name: "Avocado Toast With Egg",
                    price: "Varies",
                    summary: "Avocado toast with egg and greens, ordered with sauce or seasoning on the side.",
                    personalizedReason: "This can be balanced, but bread and seasoning make it worth checking for wheat, sodium, and carb targets.",
                    level: .caution,
                    supportsConditions: [.cholesterol],
                    avoidsAllergies: [.peanuts, .treeNuts, .fish, .shellfish],
                    supportsPreferences: [.vegetarian],
                    supportsGoals: [.safeRestaurants]
                )
            ]
        ),
        ExploreRestaurant(
            name: "Pompei Taylor Street",
            cuisine: "Italian, Casual",
            distance: "0.6",
            priceLevel: "$$",
            fitScore: 82,
            icon: "fork.knife",
            tags: ["Customizable", "Vegetarian", "Dairy Optional"],
            shortDescription: "A casual Taylor Street Italian option where salads, tomato-based dishes, and portion choices can make ordering more flexible.",
            longDescription: "Pompei Taylor Street gives the MVP a familiar nearby option with Italian staples. Olive prioritizes tomato-based, vegetable-forward, and sauce-on-the-side orders instead of richer cream sauces or oversized portions.",
            recommendedOptions: [
                RestaurantMenuOption(
                    name: "Grilled Chicken Salad",
                    price: "Varies",
                    summary: "Greens, grilled chicken, vegetables, and dressing on the side.",
                    personalizedReason: "A leaner Italian-restaurant order that keeps protein high and makes sodium easier to manage.",
                    level: .safe,
                    supportsConditions: [.diabetes, .hypertension, .cholesterol, .heartDisease],
                    avoidsAllergies: [.peanuts, .treeNuts, .fish, .shellfish],
                    supportsPreferences: [.lowCarb, .lowSodium],
                    supportsGoals: [.safeRestaurants, .improveHealth]
                ),
                RestaurantMenuOption(
                    name: "Vegetable Marinara Pasta",
                    price: "Varies",
                    summary: "Tomato-based pasta with vegetables, half portion if available, and cheese optional.",
                    personalizedReason: "Tomato sauce is usually lighter than cream sauce, but pasta portions and sodium still need attention.",
                    level: .caution,
                    supportsConditions: [.cholesterol],
                    avoidsAllergies: [.peanuts, .treeNuts, .eggs, .fish, .shellfish],
                    supportsPreferences: [.vegetarian, .dairyFree],
                    supportsGoals: [.understandNutrition]
                ),
                RestaurantMenuOption(
                    name: "Side Salad With Minestrone",
                    price: "Varies",
                    summary: "A smaller soup-and-salad order with dressing and cheese controlled.",
                    personalizedReason: "This can be lighter than a full pasta entree, but soup sodium can be high. Ask about broth and salt.",
                    level: .caution,
                    supportsConditions: [.cholesterol, .heartDisease],
                    avoidsAllergies: [.peanuts, .treeNuts, .fish, .shellfish],
                    supportsPreferences: [.vegetarian],
                    supportsGoals: [.safeRestaurants]
                )
            ]
        ),
        ExploreRestaurant(
            name: "Rosebud Taylor Street",
            cuisine: "Italian",
            distance: "0.6",
            priceLevel: "$$$",
            fitScore: 79,
            icon: "leaf.circle.fill",
            tags: ["Lean Protein", "Seafood", "Sauce Control"],
            shortDescription: "A sit-down Little Italy option where grilled proteins and vegetable sides are the safest first pass.",
            longDescription: "Rosebud Taylor Street is a neighborhood Italian restaurant near UIC. Olive steers users toward grilled proteins, red sauces, and vegetable sides while flagging cream sauces, fried items, and large pasta portions.",
            recommendedOptions: [
                RestaurantMenuOption(
                    name: "Grilled Fish With Vegetables",
                    price: "Varies",
                    summary: "Grilled fish with vegetables, lemon, and sauces served separately.",
                    personalizedReason: "A strong choice for heart-health goals when sauces are controlled. Avoid this if fish is an allergy.",
                    level: .safe,
                    supportsConditions: [.hypertension, .cholesterol, .heartDisease, .diabetes],
                    avoidsAllergies: [.peanuts, .treeNuts, .milk, .eggs, .soy, .wheat, .sesame],
                    supportsPreferences: [.lowCarb, .lowSodium],
                    supportsGoals: [.improveHealth, .understandNutrition]
                ),
                RestaurantMenuOption(
                    name: "Chicken Vesuvio, Light Potatoes",
                    price: "Varies",
                    summary: "Chicken with vegetables, lighter potatoes, and pan sauce on the side.",
                    personalizedReason: "This keeps the meal protein-forward, but the pan sauce and potatoes need portion control.",
                    level: .caution,
                    supportsConditions: [.diabetes, .cholesterol],
                    avoidsAllergies: [.peanuts, .treeNuts, .fish, .shellfish],
                    supportsPreferences: [.lowCarb],
                    supportsGoals: [.safeRestaurants]
                ),
                RestaurantMenuOption(
                    name: "Marinara Pasta, Half Portion",
                    price: "Varies",
                    summary: "Tomato-based pasta ordered as a smaller portion with cheese optional.",
                    personalizedReason: "Better than cream sauce for many profiles, but it is still a carb-heavy order.",
                    level: .caution,
                    supportsConditions: [.cholesterol],
                    avoidsAllergies: [.peanuts, .treeNuts, .fish, .shellfish],
                    supportsPreferences: [.vegetarian, .dairyFree],
                    supportsGoals: [.understandNutrition]
                )
            ]
        ),
        ExploreRestaurant(
            name: "Tuscany on Taylor",
            cuisine: "Tuscan, Italian",
            distance: "0.8",
            priceLevel: "$$$",
            fitScore: 78,
            icon: "wineglass.fill",
            tags: ["Seafood", "Vegetarian", "Gluten-Free Caution"],
            shortDescription: "A sit-down Taylor Street option where simple grilled entrees and vegetable sides are the easiest match.",
            longDescription: "Tuscany on Taylor is a traditional Italian restaurant in the UIC area. For Olive, it works best when users choose simple grilled preparations and ask questions about pasta, dairy, and wheat.",
            recommendedOptions: [
                RestaurantMenuOption(
                    name: "Grilled Salmon With Greens",
                    price: "Varies",
                    summary: "Grilled salmon, greens or vegetables, lemon, and sauce on the side.",
                    personalizedReason: "Protein and vegetables make this one of the stronger fits, but fish allergies should avoid it.",
                    level: .safe,
                    supportsConditions: [.diabetes, .hypertension, .cholesterol, .heartDisease],
                    avoidsAllergies: [.peanuts, .treeNuts, .milk, .eggs, .soy, .wheat],
                    supportsPreferences: [.lowCarb, .lowSodium],
                    supportsGoals: [.improveHealth, .safeRestaurants]
                ),
                RestaurantMenuOption(
                    name: "Chicken Paillard",
                    price: "Varies",
                    summary: "Thin grilled chicken with arugula or vegetables and dressing on the side.",
                    personalizedReason: "A lean, lower-carb order when breading is avoided and dressing is controlled.",
                    level: .safe,
                    supportsConditions: [.diabetes, .hypertension, .cholesterol, .heartDisease],
                    avoidsAllergies: [.peanuts, .treeNuts, .fish, .shellfish],
                    supportsPreferences: [.lowCarb, .lowSodium],
                    supportsGoals: [.safeRestaurants, .improveHealth]
                ),
                RestaurantMenuOption(
                    name: "Vegetable Pasta With Red Sauce",
                    price: "Varies",
                    summary: "Vegetables with tomato sauce, smaller pasta portion, and cheese optional.",
                    personalizedReason: "A workable vegetarian order, but wheat and carb load make it a caution item.",
                    level: .caution,
                    supportsConditions: [.cholesterol],
                    avoidsAllergies: [.peanuts, .treeNuts, .fish, .shellfish],
                    supportsPreferences: [.vegetarian, .dairyFree],
                    supportsGoals: [.understandNutrition]
                )
            ]
        ),
        ExploreRestaurant(
            name: "Sandella's Flatbread Cafe",
            cuisine: "Flatbreads, Wraps",
            distance: "0.8",
            priceLevel: "$",
            fitScore: 75,
            icon: "takeoutbag.and.cup.and.straw.fill",
            tags: ["Fast Casual", "Customizable", "Halal-Friendly Ask"],
            shortDescription: "A campus dining option where wraps and bowls can be adjusted, but wheat and sauces need extra attention.",
            longDescription: "Sandella's gives the MVP a campus-friendly fast-casual option. Olive treats it as a customizable stop where users should ask about wrap ingredients, sauces, and allergen handling.",
            recommendedOptions: [
                RestaurantMenuOption(
                    name: "Grilled Chicken Salad Bowl",
                    price: "Varies",
                    summary: "Grilled chicken over greens with vegetables and dressing on the side.",
                    personalizedReason: "This avoids the flatbread base and keeps the order protein-forward with more vegetables.",
                    level: .safe,
                    supportsConditions: [.diabetes, .hypertension, .cholesterol, .heartDisease],
                    avoidsAllergies: [.peanuts, .treeNuts, .fish, .shellfish],
                    supportsPreferences: [.lowCarb, .lowSodium],
                    supportsGoals: [.safeRestaurants, .improveHealth]
                ),
                RestaurantMenuOption(
                    name: "Vegetable Hummus Bowl",
                    price: "Varies",
                    summary: "Vegetables, hummus, greens, and sauce kept light.",
                    personalizedReason: "Plant-forward and filling, but sesame and sodium can be issues because hummus often contains tahini.",
                    level: .caution,
                    supportsConditions: [.cholesterol, .heartDisease],
                    avoidsAllergies: [.milk, .eggs, .fish, .shellfish],
                    supportsPreferences: [.vegetarian, .vegan, .dairyFree],
                    supportsGoals: [.improveHealth]
                ),
                RestaurantMenuOption(
                    name: "Turkey Wrap, Sauce Light",
                    price: "Varies",
                    summary: "Turkey, vegetables, and light sauce in a wrap, with chips skipped.",
                    personalizedReason: "A reasonable fast option, but the wrap adds wheat and carbs. Ask about sodium in deli meat.",
                    level: .caution,
                    supportsConditions: [.diabetes],
                    avoidsAllergies: [.peanuts, .treeNuts, .fish, .shellfish],
                    supportsGoals: [.safeRestaurants]
                )
            ]
        )
    ]
}

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? 0
        let rows = rows(for: subviews, maxWidth: maxWidth)
        let height = rows.reduce(CGFloat.zero) { total, row in
            total + row.height
        } + CGFloat(max(rows.count - 1, 0)) * spacing

        return CGSize(width: maxWidth, height: height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let rows = rows(for: subviews, maxWidth: bounds.width)
        var y = bounds.minY

        for row in rows {
            var x = bounds.minX

            for item in row.items {
                item.subview.place(
                    at: CGPoint(x: x, y: y),
                    proposal: ProposedViewSize(item.size)
                )

                x += item.size.width + spacing
            }

            y += row.height + spacing
        }
    }

    private func rows(
        for subviews: Subviews,
        maxWidth: CGFloat
    ) -> [FlowRow] {
        var rows: [FlowRow] = []
        var currentItems: [FlowItem] = []
        var currentWidth: CGFloat = 0
        var currentHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            let nextWidth = currentItems.isEmpty
                ? size.width
                : currentWidth + spacing + size.width

            if nextWidth > maxWidth, !currentItems.isEmpty {
                rows.append(
                    FlowRow(items: currentItems, height: currentHeight)
                )
                currentItems = []
                currentWidth = 0
                currentHeight = 0
            }

            currentItems.append(FlowItem(subview: subview, size: size))
            currentWidth = currentItems.count == 1
                ? size.width
                : currentWidth + spacing + size.width
            currentHeight = max(currentHeight, size.height)
        }

        if !currentItems.isEmpty {
            rows.append(FlowRow(items: currentItems, height: currentHeight))
        }

        return rows
    }
}

private struct FlowRow {
    let items: [FlowItem]
    let height: CGFloat
}

private struct FlowItem {
    let subview: LayoutSubview
    let size: CGSize
}

#Preview {
    Explore()
}
