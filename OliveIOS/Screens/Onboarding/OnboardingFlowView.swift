//
//  OnboardingFlowView.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct OnboardingFlowView: View {

    @StateObject private var onboardingVM =
        OnboardingViewModel()

    var body: some View {

        NavigationStack {

            WelcomeView()
        }
        .environmentObject(onboardingVM)
    }
}

#Preview {
    OnboardingFlowView()
}
