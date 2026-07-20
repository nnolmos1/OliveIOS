//
//  OnboardingCompleteView.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct OnboardingCompleteView: View {
    
    @EnvironmentObject private var onboardingVM: OnboardingViewModel

    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    OliveTheme.onboardingBackground,
                    OliveTheme.onboardingGradientEnd
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {

                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 90))
                    .foregroundStyle(OliveTheme.primaryGreen)

                VStack(spacing: 12) {

                    Text("You're All Set 🎉")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(OliveTheme.navyText)

                    Text("Olive is now personalized to your needs.")
                        .foregroundStyle(.secondary)

                    Text("Let's start making nutrition more accessible.")
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)

                Spacer()

                Button {

                    onboardingVM.saveProfile()
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
            .environmentObject(OnboardingViewModel())
    }
}
