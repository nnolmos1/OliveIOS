//
//  AllergiesView.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct AllergiesView: View {

    @EnvironmentObject var onboardingVM:
        OnboardingViewModel

    @State private var searchText = ""

    private var filteredAllergies: [FoodAllergy] {

        if searchText.isEmpty {
            return FoodAllergy.allCases
        }

        return FoodAllergy.allCases.filter {
            $0.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {

        ZStack {

            OliveTheme.onboardingBackground
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                // Progress

                VStack(alignment: .leading, spacing: 8) {

                    Text("Step 2 of 5")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ProgressView(value: 0.4)
                        .tint(OliveTheme.primaryGreen)
                }

                VStack(alignment: .leading, spacing: 10) {

                    Text("Food Allergies")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(OliveTheme.navyText)

                    Text("Select any allergies you have.")
                        .foregroundStyle(.secondary)
                }

                TextField(
                    "Search allergies...",
                    text: $searchText
                )
                .textFieldStyle(.roundedBorder)

                ScrollView {

                    LazyVStack(spacing: 14) {

                        ForEach(filteredAllergies) { allergy in

                            SelectionCard(
                                title: allergy.rawValue,
                                icon: allergy.icon,
                                isSelected:
                                    onboardingVM.hasAllergy(allergy)
                            ) {

                                onboardingVM.toggleAllergy(allergy)
                            }
                        }
                    }
                }

                NavigationLink {

                    PreferencesView()

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

        AllergiesView()
            .environmentObject(
                OnboardingViewModel()
            )
    }
}
