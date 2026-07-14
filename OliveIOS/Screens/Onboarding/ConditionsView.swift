import SwiftUI

struct ConditionsView: View {

    @EnvironmentObject var onboardingVM:
        OnboardingViewModel
    
    @State private var searchText = ""

    private var filteredConditions: [MedicalCondition] {

        if searchText.isEmpty {
            return MedicalCondition.allCases
        }

        return MedicalCondition.allCases.filter {
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

                    Text("Step 1 of 5")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ProgressView(value: 0.2)
                        .tint(
                            Color(
                                red: 0.42,
                                green: 0.58,
                                blue: 0.46
                            )
                        )
                }

                VStack(alignment: .leading, spacing: 10) {

                    Text("Tell us about your health")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Select any conditions that apply to you.")
                        .foregroundStyle(.secondary)
                }

                // Search
                TextField(
                    "Search conditions...",
                    text: $searchText
                )
                .textFieldStyle(.roundedBorder)

                ScrollView {

                    LazyVStack(spacing: 14) {

                        ForEach(filteredConditions) { condition in

                            SelectionCard(
                                title: condition.rawValue,
                                icon: condition.icon,
                                isSelected: onboardingVM.hasCondition(condition)
                            ) {
                                onboardingVM.toggleCondition(condition)
                            }
                        }
                    }
                }

                NavigationLink {

                    AllergiesView()

                } label: {

                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .buttonStyle(OlivePrimaryButton())

            }
            .padding(24)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationStack {
        ConditionsView()
            .environmentObject(OnboardingViewModel())
    }
}
