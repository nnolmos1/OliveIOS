//
//  OnboardingCompleteView.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct OnboardingCompleteView: View {
    
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    Color(
                        red: 0.97,
                        green: 0.96,
                        blue: 0.94
                    ),
                    Color(
                        red: 0.92,
                        green: 0.95,
                        blue: 0.92
                    )
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {

                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 90))
                    .foregroundStyle(
                        Color(
                            red: 0.42,
                            green: 0.58,
                            blue: 0.46
                        )
                    )

                VStack(spacing: 12) {

                    Text("You're All Set 🎉")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Olive is now personalized to your needs.")
                        .foregroundStyle(.secondary)

                    Text("Let's start making nutrition more accessible.")
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)

                Spacer()

                Button {

                    hasCompletedOnboarding = true

                } label: {

                    Text("Start Exploring")
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .buttonStyle(OlivePrimaryButton())
                .padding(.horizontal)

            }
            .padding()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        OnboardingCompleteView()
    }
}
