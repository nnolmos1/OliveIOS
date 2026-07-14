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

            Color(
                red: 0.97,
                green: 0.96,
                blue: 0.94
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                // Progress

                VStack(alignment: .leading, spacing: 8) {

                    Text("Step 2 of 5")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ProgressView(value: 0.4)
                        .tint(
                            Color(
                                red: 0.42,
                                green: 0.58,
                                blue: 0.46
                            )
                        )
                }

                VStack(alignment: .leading, spacing: 10) {

                    Text("Food Allergies")
                        .font(.largeTitle)
                        .fontWeight(.bold)

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
