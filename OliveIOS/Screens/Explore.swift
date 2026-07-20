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

    private let restaurants = ExploreRestaurant.demoRestaurants
    private let oliveGreen = OliveTheme.primaryGreen
    private let deepOlive = OliveTheme.deepOlive
    private let warmBackground = OliveTheme.warmBackground
    private let cardBackground = OliveTheme.cardBackground

    private var filteredRestaurants: [ExploreRestaurant] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else {
            return restaurants
        }

        return restaurants.filter { restaurant in
            restaurant.name.localizedCaseInsensitiveContains(query)
            || restaurant.cuisine.localizedCaseInsensitiveContains(query)
            || restaurant.tags.contains {
                $0.localizedCaseInsensitiveContains(query)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    headerSection
                    searchSection
                    personalizedSummary
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

                    Text("Nearby picks matched to your profile.")
                        .font(.system(size: 14))
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

    private var personalizedSummary: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Personalized For")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(deepOlive)

            FlowLayout(spacing: 8) {
                ForEach(profileSummaryTags, id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(deepOlive)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.74))
                        )
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(cardBackground)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18)
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

                fitBadge(score: restaurant.fitScore)
            }

            Text(restaurant.shortDescription)
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

    private var profileSummaryTags: [String] {
        var tags: [String] = []

        tags.append(contentsOf: profile.conditions.map(\.rawValue).sorted())
        tags.append(contentsOf: profile.allergies.map(\.rawValue).sorted())
        tags.append(contentsOf: profile.dietaryPreferences.map(\.rawValue).sorted())

        if let goal = profile.goal {
            tags.append(goal.rawValue)
        }

        if tags.isEmpty {
            return [
                "Low Sodium",
                "Diabetes Friendly",
                "Peanut Aware"
            ]
        }

        return Array(tags.prefix(5))
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
            Text("Top Recommended Menu Options")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(deepOlive)

            ForEach(restaurant.recommendedOptions) { option in
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

            Text(option.personalizedReason)
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
    static let demoRestaurants: [ExploreRestaurant] = [
        ExploreRestaurant(
            name: "Green Leaf Cafe",
            cuisine: "Salads, Bowls",
            distance: "0.3",
            priceLevel: "$$",
            fitScore: 92,
            icon: "leaf.fill",
            tags: ["Low Sodium", "Diabetes Friendly", "Peanut Aware"],
            shortDescription: "Fresh bowls with plenty of vegetable-forward options and flexible dressings.",
            longDescription: "Green Leaf Cafe is a fast casual spot focused on grain bowls, salads, and lean proteins. Most dishes can be customized with sauces on the side and extra vegetables.",
            recommendedOptions: [
                RestaurantMenuOption(
                    name: "Grilled Salmon Greens Bowl",
                    price: "$15.50",
                    summary: "Salmon, greens, cucumber, avocado, herbs, and lemon vinaigrette.",
                    personalizedReason: "A strong option for blood sugar goals because it is protein-forward and lower in refined carbs. Ask for dressing on the side to manage sodium.",
                    level: .safe
                ),
                RestaurantMenuOption(
                    name: "Chicken Harvest Salad",
                    price: "$13.75",
                    summary: "Grilled chicken, mixed greens, roasted vegetables, apple, and seeds.",
                    personalizedReason: "Balanced protein and fiber. Confirm seed toppings if you have cross-contact concerns with nut or peanut allergens.",
                    level: .safe
                ),
                RestaurantMenuOption(
                    name: "Tomato Basil Soup",
                    price: "$6.25",
                    summary: "House tomato soup with basil and olive oil.",
                    personalizedReason: "Soups can run high in sodium, so this is better as a small side or with sodium details confirmed.",
                    level: .caution
                )
            ]
        ),
        ExploreRestaurant(
            name: "Fresh & Co.",
            cuisine: "Wraps, Bowls",
            distance: "0.6",
            priceLevel: "$$",
            fitScore: 88,
            icon: "fork.knife",
            tags: ["High Fiber", "Customizable", "Low Carb"],
            shortDescription: "Build-your-own meals make it easier to avoid allergens and adjust carbs.",
            longDescription: "Fresh & Co. offers wraps, bowls, soups, and salads with clear ingredient choices. It is a practical fit when you want control over sauces, grains, and toppings.",
            recommendedOptions: [
                RestaurantMenuOption(
                    name: "Turkey Lettuce Wrap",
                    price: "$12.25",
                    summary: "Turkey, romaine, tomato, cucumber, avocado, and mustard vinaigrette.",
                    personalizedReason: "Lower in refined carbs than a traditional wrap and easy to keep sauces separate.",
                    level: .safe
                ),
                RestaurantMenuOption(
                    name: "Chicken Quinoa Bowl",
                    price: "$14.25",
                    summary: "Chicken, quinoa, greens, peppers, and herb yogurt sauce.",
                    personalizedReason: "Quinoa adds carbs, but the protein and fiber make it a reasonable choice with portion awareness.",
                    level: .caution
                )
            ]
        ),
        ExploreRestaurant(
            name: "The Wholesome Table",
            cuisine: "Healthy, Organic",
            distance: "0.7",
            priceLevel: "$$$",
            fitScore: 85,
            icon: "carrot.fill",
            tags: ["Organic", "Vegetarian", "Low Sodium"],
            shortDescription: "A quieter sit-down option with lighter plates and vegetable sides.",
            longDescription: "The Wholesome Table focuses on seasonal produce, lean proteins, and simple preparations. It has several dishes that can be adjusted for sodium and carb goals.",
            recommendedOptions: [
                RestaurantMenuOption(
                    name: "Herb Chicken Plate",
                    price: "$18.00",
                    summary: "Roasted chicken, greens, squash, and herb sauce.",
                    personalizedReason: "A balanced meal with lean protein and vegetables. Ask for sauce on the side for better sodium control.",
                    level: .safe
                ),
                RestaurantMenuOption(
                    name: "Lentil Vegetable Stew",
                    price: "$12.50",
                    summary: "Lentils, carrots, greens, tomato, and herbs.",
                    personalizedReason: "High fiber is useful, but the sodium level may vary. Ask about broth or salt content before ordering.",
                    level: .caution
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
