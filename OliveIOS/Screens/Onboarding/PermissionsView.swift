//
//  PermissionsView.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct PermissionsView: View {

    @EnvironmentObject var onboardingVM:
        OnboardingViewModel

    @State private var locationEnabled = false
    @State private var cameraEnabled = false

    var body: some View {

        ZStack {

            OliveTheme.onboardingBackground
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {

                // Progress

                VStack(alignment: .leading, spacing: 8) {

                    Text("Step 5 of 5")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ProgressView(value: 1.0)
                        .tint(OliveTheme.primaryGreen)
                }

                VStack(alignment: .leading, spacing: 10) {

                    Text("Enable Olive")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(OliveTheme.navyText)

                    Text("Help Olive provide personalized recommendations and menu scanning.")
                        .foregroundStyle(.secondary)
                }

                VStack(spacing: 16) {

                    Button {

                        locationEnabled.toggle()

                        onboardingVM.setLocationPermission(
                            locationEnabled
                        )

                    } label: {

                        PermissionCard(
                            icon: "location.fill",
                            title: "Location Access",
                            description:
                                "Find nearby restaurants that fit your dietary needs.",
                            isEnabled: locationEnabled
                        )
                    }
                    .buttonStyle(.plain)

                    Button {

                        cameraEnabled.toggle()

                        onboardingVM.setCameraPermission(
                            cameraEnabled
                        )

                    } label: {

                        PermissionCard(
                            icon: "camera.fill",
                            title: "Camera Access",
                            description:
                                "Scan menus and ingredient labels instantly.",
                            isEnabled: cameraEnabled
                        )
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                NavigationLink {

                    OnboardingCompleteView()

                } label: {

                    Text("Finish Setup")
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

        PermissionsView()
            .environmentObject(
                OnboardingViewModel()
            )
    }
}
