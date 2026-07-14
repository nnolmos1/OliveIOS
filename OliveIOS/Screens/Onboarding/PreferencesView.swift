//
//  PreferencesView.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct PreferencesView: View {

    @EnvironmentObject var onboardingVM:
        OnboardingViewModel

    @State private var searchText = ""

    private var filteredPreferences: [DietaryPreference] {

        if searchText.isEmpty {
            return DietaryPreference.allCases
        }

        return DietaryPreference.allCases.filter {
            $0.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {

        ZStack {

            Color(
                red: 0.97,
                green: 0.96,
                blue: 0.94
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                // Progress

                VStack(alignment: .leading, spacing: 8) {

                    Text("Step 3 of 5")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ProgressView(value: 0.6)
                        .tint(
                            Color(
                                red: 0.42,
                                green: 0.58,
                                blue: 0.46
                            )
                        )
                }

                VStack(alignment: .leading, spacing: 10) {

                    Text("Dietary Preferences")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Tell Olive how you prefer to eat.")
                        .foregroundStyle(.secondary)
                }

                TextField(
                    "Search preferences...",
                    text: $searchText
                )
                .textFieldStyle(.roundedBorder)

                ScrollView {

                    LazyVStack(spacing: 14) {

                        ForEach(filteredPreferences) { preference in

                            SelectionCard(
                                title: preference.rawValue,
                                icon: preference.icon,
                                isSelected:
                                    onboardingVM.hasPreference(preference)
                            ) {

                                onboardingVM.togglePreference(preference)
                            }
                        }
                    }
                }

                NavigationLink {

                    GoalsView()

                } label: {

                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .buttonStyle(OlivePrimaryButton())

            }
            .padding(24)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {

    NavigationStack {

        PreferencesView()
            .environmentObject(
                OnboardingViewModel()
            )
    }
}
