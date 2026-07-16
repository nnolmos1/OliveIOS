//
//  Home.swift
//  Olive
//
//  Created by SandboxLab on 7/1/26.
//

import SwiftUI

struct Home: View {

    private let oliveGreen = Color(red: 0.20, green: 0.39, blue: 0.21)
    private let deepOlive = Color(red: 0.11, green: 0.20, blue: 0.13)
    private let warmBackground = Color(red: 0.95, green: 0.93, blue: 0.86)
    private let cardBackground = Color.white.opacity(0.88)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    headerSection
                    healthProfileSection
                    todaysSummarySection
                    quickActionsSection
                    askOliveSection
                }
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(warmBackground.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
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
                Text("Good morning, Alex")
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

                VStack(spacing: 10) {
                    profileRow(
                        title: "Type 2 Diabetes",
                        detail: "Manage blood sugar",
                        systemImage: "drop.fill",
                        tint: Color(red: 0.50, green: 0.58, blue: 0.50)
                    )

                    profileRow(
                        title: "Hypertension",
                        detail: "Watch sodium",
                        systemImage: "heart.fill",
                        tint: Color(red: 0.56, green: 0.42, blue: 0.38)
                    )

                    profileRow(
                        title: "Peanut Allergy",
                        detail: "Avoid peanut ingredients",
                        systemImage: "exclamationmark.shield.fill",
                        tint: Color(red: 0.66, green: 0.49, blue: 0.24)
                    )
                }
            }
        }
    }

    private var todaysSummarySection: some View {
        dashboardCard {
            VStack(alignment: .leading, spacing: 14) {
                sectionHeader(
                    title: "Today's Summary",
                    systemImage: "chart.bar.fill"
                )

                HStack(spacing: 10) {
                    summaryTile(
                        value: "1,450",
                        unit: "mg",
                        label: "Sodium",
                        status: "On track",
                        systemImage: "drop"
                    )

                    summaryTile(
                        value: "112",
                        unit: "g",
                        label: "Carbs",
                        status: "Steady",
                        systemImage: "cube"
                    )

                    summaryTile(
                        value: "80%",
                        unit: "",
                        label: "Goal Fit",
                        status: "Good",
                        systemImage: "leaf"
                    )
                }
            }
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
                    subtitle: "Explore nearby",
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

    private func summaryTile(
        value: String,
        unit: String,
        label: String,
        status: String,
        systemImage: String
    ) -> some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 19, weight: .medium))
                .foregroundStyle(oliveGreen)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 18, weight: .bold))

                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(deepOlive)

            VStack(spacing: 2) {
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(deepOlive.opacity(0.78))

                Text(status)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.74))
        )
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

#Preview {
    Home()
}
