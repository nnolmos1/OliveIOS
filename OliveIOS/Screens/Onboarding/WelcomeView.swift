import SwiftUI

struct WelcomeView: View {

    @State private var animate = false

    var body: some View {

        ZStack {

            // Background
            LinearGradient(
                colors: [
                    OliveTheme.onboardingBackground,
                    OliveTheme.onboardingGradientEnd
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {

                Spacer()

                // Logo Area
                ZStack {

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    OliveTheme.primaryGreen,
                                    OliveTheme.deepOlive
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 130, height: 130)

                    Image(systemName: "leaf.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)

                }
                .scaleEffect(animate ? 1 : 0.8)
                .opacity(animate ? 1 : 0)

                VStack(spacing: 16) {

                    Text("Welcome to Olive")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(OliveTheme.navyText)

                    Text("Making nutrition accessible through personalized AI guidance.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 24)

                }
                .opacity(animate ? 1 : 0)

                Spacer()

                VStack(spacing: 12) {

                    Text("Olive helps you make safer food choices based on your health conditions, allergies, and dietary needs.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button {

                        // Navigate to ConditionsView

                    } label: {

                        HStack {
                            NavigationLink {
                                ConditionsView()
                            } label: {
                                Text("Get Started")
                            }
                            .buttonStyle(OlivePrimaryButton())

                            Image(systemName: "arrow.right")
                        }
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                    }
                    .buttonStyle(OlivePrimaryButton())

                }
                .padding(.horizontal, 24)

            }
            .padding(.bottom, 40)

        }
        .onAppear {

            withAnimation(
                .spring(
                    response: 0.8,
                    dampingFraction: 0.75
                )
            ) {
                animate = true
            }
        }
    }
}

#Preview {
    WelcomeView()
}
