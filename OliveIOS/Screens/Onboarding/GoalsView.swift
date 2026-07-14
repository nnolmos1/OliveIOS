//
//  GoalsView.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct GoalsView: View {

    @EnvironmentObject var onboardingVM:
        OnboardingViewModel

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

                    Text("Step 4 of 5")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ProgressView(value: 0.8)
                        .tint(
                            Color(
                                red: 0.42,
                                green: 0.58,
                                blue: 0.46
                            )
                        )
                }

                VStack(alignment: .leading, spacing: 10) {

                    Text("Your Primary Goal")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("What would you like Olive to help with most?")
                        .foregroundStyle(.secondary)
                }

                ScrollView {

                    LazyVStack(spacing: 14) {

                        ForEach(UserGoal.allCases) { goal in

                            SelectionCard(
                                title: goal.rawValue,
                                icon: goal.icon,
                                isSelected:
                                    onboardingVM.hasGoal(goal)
                            ) {

                                onboardingVM.setGoal(goal)
                            }
                        }
                    }
                }

                NavigationLink {

                    PermissionsView()

                } label: {

                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .buttonStyle(OlivePrimaryButton())
                .disabled(onboardingVM.userProfile.goal == nil)

            }
            .padding(24)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {

    NavigationStack {

        GoalsView()
            .environmentObject(
                OnboardingViewModel()
            )
    }
}
