//
//  Home.swift
//  Olive
//
//  Created by SandboxLab on 7/1/26.
//

import SwiftUI

struct Home: View {

    @State private var profile = UserProfileStorage.load()

    private let oliveGreen = OliveTheme.primaryGreen
    private let deepOlive = OliveTheme.deepOlive
    private let warmBackground = OliveTheme.warmBackground
    private let cardBackground = OliveTheme.cardBackground

    private var greetingName: String {
        let trimmedName = profile.fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.isEmpty ? "there" : trimmedName
    }

    private var healthProfileItems: [HealthProfileItem] {
        var items: [HealthProfileItem] = []

        items.append(
            contentsOf: profile.conditions.sortedByName.map { condition in
                HealthProfileItem(
                    title: condition.rawValue,
                    detail: "Medical condition",
                    systemImage: condition.icon,
                    tint: Color(red: 0.50, green: 0.58, blue: 0.50)
                )
            }
        )

        items.append(
            contentsOf: profile.allergies.sortedByName.map { allergy in
                HealthProfileItem(
                    title: allergy.rawValue,
                    detail: "Food allergy",
                    systemImage: allergy.icon,
                    tint: Color(red: 0.66, green: 0.49, blue: 0.24)
                )
            }
        )

        items.append(
            contentsOf: profile.dietaryPreferences.sortedByName.map { preference in
                HealthProfileItem(
                    title: preference.rawValue,
                    detail: "Dietary preference",
                    systemImage: preference.icon,
                    tint: oliveGreen
                )
            }
        )

        if let goal = profile.goal {
            items.append(
                HealthProfileItem(
                    title: goal.rawValue,
                    detail: "Primary goal",
                    systemImage: goal.icon,
                    tint: Color(red: 0.45, green: 0.52, blue: 0.68)
                )
            )
        }

        return items
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    headerSection
                    healthProfileSection
                    askOliveSection
                    quickActionsSection
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
        HStack(alignment: .top, spacing: 14) {
            Image("OliveLeaf")
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
                .padding(7)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.75))
                )

            VStack(alignment: .leading, spacing: 6) {
                Text("Good morning, \(greetingName)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(deepOlive)

                Text("Olive helps you choose meals that fit your health profile.")
                    .font(.system(size: 15))
                    .foregroundStyle(deepOlive.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Button {
            } label: {
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(deepOlive)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.72))
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Notifications")
        }
    }

    private var healthProfileSection: some View {
        dashboardCard {
            VStack(alignment: .leading, spacing: 14) {
                sectionHeader(
                    title: "Your Health Profile",
                    systemImage: "heart.text.square"
                )

                if healthProfileItems.isEmpty {
                    emptyHealthProfileRow
                } else {
                    VStack(spacing: 10) {
                        ForEach(healthProfileItems.prefix(5)) { item in
                            profileRow(
                                title: item.title,
                                detail: item.detail,
                                systemImage: item.systemImage,
                                tint: item.tint
                            )
                        }

                        if healthProfileItems.count > 5 {
                            Text("+ \(healthProfileItems.count - 5) more saved profile details")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(deepOlive.opacity(0.68))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 2)
                        }
                    }
                }
            }
        }
    }

    private var emptyHealthProfileRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(oliveGreen)
                .frame(width: 34, height: 34)
                .background(
                    Circle()
                        .fill(oliveGreen.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("No profile details yet")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(deepOlive)

                Text("Complete onboarding or update your profile.")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(deepOlive)

            HStack(spacing: 12) {
                actionCard(
                    title: "Scan a Menu",
                    subtitle: "Get item guidance",
                    systemImage: "viewfinder",
                    isPrimary: true
                )

                actionCard(
                    title: "Find Food",
                    subtitle: "Explore nearby options",
                    systemImage: "magnifyingglass",
                    isPrimary: false
                )
            }
        }
    }

    private var askOliveSection: some View {
        dashboardCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(
                            Circle()
                                .fill(oliveGreen)
                        )

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Ask Olive")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(deepOlive)

                        Text("AI nutrition assistant")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "message")
                        .font(.system(size: 22))
                        .foregroundStyle(deepOlive.opacity(0.74))
                }

                HStack(spacing: 10) {
                    Text("Can I eat sushi with diabetes?")
                        .font(.system(size: 14))
                        .foregroundStyle(deepOlive.opacity(0.75))

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.78))
                )
            }
        }
    }

    private func dashboardCard<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(cardBackground)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.75), lineWidth: 1)
            }
            .shadow(color: deepOlive.opacity(0.08), radius: 12, y: 6)
    }

    private func sectionHeader(
        title: String,
        systemImage: String
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(oliveGreen)

            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(deepOlive)
        }
    }

    private func profileRow(
        title: String,
        detail: String,
        systemImage: String,
        tint: Color
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(tint)
                .frame(width: 34, height: 34)
                .background(
                    Circle()
                        .fill(tint.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(deepOlive)

                Text(detail)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
    }

    private func actionCard(
        title: String,
        subtitle: String,
        systemImage: String,
        isPrimary: Bool
    ) -> some View {
        Button {
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(isPrimary ? .white : oliveGreen)
                    .frame(width: 42, height: 42)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isPrimary ? Color.white.opacity(0.18) : oliveGreen.opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 15, weight: .bold))

                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(isPrimary ? Color.white.opacity(0.78) : Color.secondary)
                }
            }
            .foregroundStyle(isPrimary ? .white : deepOlive)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isPrimary ? oliveGreen : cardBackground)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(isPrimary ? 0.18 : 0.7), lineWidth: 1)
            }
            .shadow(color: deepOlive.opacity(0.08), radius: 10, y: 5)
        }
        .buttonStyle(.plain)
    }
}

private struct HealthProfileItem: Identifiable {
    let title: String
    let detail: String
    let systemImage: String
    let tint: Color

    var id: String {
        "\(detail)-\(title)"
    }
}

private extension Set where Element: RawRepresentable, Element.RawValue == String {
    var sortedByName: [Element] {
        sorted {
            $0.rawValue < $1.rawValue
        }
    }
}

#Preview {
    Home()
}
