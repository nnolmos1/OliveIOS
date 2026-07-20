//
//  Profile.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct Profile: View {

    @State private var profile = UserProfileStorage.load()

    private let oliveGreen = OliveTheme.primaryGreen
    private let deepOlive = OliveTheme.deepOlive
    private let warmBackground = OliveTheme.warmBackground
    private let cardBackground = OliveTheme.cardBackground

    private var displayName: String {
        let trimmedName = profile.fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.isEmpty ? "Your Profile" : trimmedName
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    headerSection
                    personalInfoSection
                    conditionSection
                    allergySection
                    preferenceSection
                    goalSection
                }
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(warmBackground.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var headerSection: some View {
        HStack(spacing: 14) {
            Image("OliveLeaf")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .padding(9)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.78))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(displayName)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(deepOlive)
                    .lineLimit(2)

                Text("Manage the details Olive uses for safer recommendations.")
                    .font(.system(size: 14))
                    .foregroundStyle(deepOlive.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
    }

    private var personalInfoSection: some View {
        profileCard {
            VStack(alignment: .leading, spacing: 14) {
                sectionHeader(title: "Personal Info", systemImage: "person.crop.circle")

                profileTextField(
                    title: "Full Name",
                    placeholder: "Add your name",
                    text: $profile.fullName,
                    keyboardType: .default
                )

                DatePicker(
                    "Birthday",
                    selection: $profile.birthday,
                    displayedComponents: .date
                )
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(deepOlive)
                .tint(oliveGreen)
                .onChange(of: profile.birthday) { _, _ in
                    saveProfile()
                }

                profileTextField(
                    title: "Email",
                    placeholder: "name@example.com",
                    text: $profile.email,
                    keyboardType: .emailAddress
                )

                profileTextField(
                    title: "Phone",
                    placeholder: "Optional",
                    text: $profile.phoneNumber,
                    keyboardType: .phonePad
                )
            }
        }
    }

    private var conditionSection: some View {
        editableSection(
            title: "Medical Conditions",
            systemImage: "heart.text.square",
            items: MedicalCondition.allCases,
            isSelected: { profile.conditions.contains($0) },
            toggle: toggleCondition
        )
    }

    private var allergySection: some View {
        editableSection(
            title: "Allergies",
            systemImage: "exclamationmark.shield",
            items: FoodAllergy.allCases,
            isSelected: { profile.allergies.contains($0) },
            toggle: toggleAllergy
        )
    }

    private var preferenceSection: some View {
        editableSection(
            title: "Dietary Preferences",
            systemImage: "leaf",
            items: DietaryPreference.allCases,
            isSelected: { profile.dietaryPreferences.contains($0) },
            toggle: togglePreference
        )
    }

    private var goalSection: some View {
        profileCard {
            VStack(alignment: .leading, spacing: 14) {
                sectionHeader(title: "Nutrition Goal", systemImage: "target")

                VStack(spacing: 10) {
                    ForEach(UserGoal.allCases) { goal in
                        Button {
                            profile.goal = goal
                            saveProfile()
                        } label: {
                            selectableRow(
                                title: goal.rawValue,
                                systemImage: goal.icon,
                                isSelected: profile.goal == goal
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func editableSection<Item: Identifiable>(
        title: String,
        systemImage: String,
        items: [Item],
        isSelected: @escaping (Item) -> Bool,
        toggle: @escaping (Item) -> Void
    ) -> some View where Item.ID == String, Item: RawRepresentable, Item.RawValue == String {
        profileCard {
            VStack(alignment: .leading, spacing: 14) {
                sectionHeader(title: title, systemImage: systemImage)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ],
                    spacing: 10
                ) {
                    ForEach(items) { item in
                        Button {
                            toggle(item)
                        } label: {
                            profileChip(
                                title: item.rawValue,
                                isSelected: isSelected(item)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func profileTextField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(deepOlive.opacity(0.7))

            TextField(placeholder, text: text)
                .font(.system(size: 15))
                .keyboardType(keyboardType)
                .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .words)
                .autocorrectionDisabled(keyboardType == .emailAddress)
                .padding(.horizontal, 13)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.78))
                )
                .onChange(of: text.wrappedValue) { _, _ in
                    saveProfile()
                }
        }
    }

    private func selectableRow(
        title: String,
        systemImage: String,
        isSelected: Bool
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(isSelected ? .white : oliveGreen)
                .frame(width: 34, height: 34)
                .background(
                    Circle()
                        .fill(isSelected ? oliveGreen : oliveGreen.opacity(0.12))
                )

            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(deepOlive)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(isSelected ? oliveGreen : Color.secondary.opacity(0.45))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? oliveGreen.opacity(0.1) : Color.white.opacity(0.72))
        )
    }

    private func profileChip(
        title: String,
        isSelected: Bool
    ) -> some View {
        HStack(spacing: 7) {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "plus.circle")
                .font(.system(size: 13, weight: .semibold))

            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .lineLimit(2)
                .minimumScaleFactor(0.82)
        }
        .foregroundStyle(isSelected ? .white : deepOlive)
        .frame(maxWidth: .infinity, minHeight: 44)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 13)
                .fill(isSelected ? oliveGreen : Color.white.opacity(0.72))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 13)
                .stroke(isSelected ? Color.clear : oliveGreen.opacity(0.18), lineWidth: 1)
        }
    }

    private func profileCard<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(cardBackground)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.75), lineWidth: 1)
            }
            .shadow(color: deepOlive.opacity(0.08), radius: 12, y: 6)
    }

    private func sectionHeader(
        title: String,
        systemImage: String
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(oliveGreen)

            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(deepOlive)
        }
    }

    private func toggleCondition(_ condition: MedicalCondition) {
        if profile.conditions.contains(condition) {
            profile.conditions.remove(condition)
        } else {
            profile.conditions.insert(condition)
        }

        saveProfile()
    }

    private func toggleAllergy(_ allergy: FoodAllergy) {
        if profile.allergies.contains(allergy) {
            profile.allergies.remove(allergy)
        } else {
            profile.allergies.insert(allergy)
        }

        saveProfile()
    }

    private func togglePreference(_ preference: DietaryPreference) {
        if profile.dietaryPreferences.contains(preference) {
            profile.dietaryPreferences.remove(preference)
        } else {
            profile.dietaryPreferences.insert(preference)
        }

        saveProfile()
    }

    private func saveProfile() {
        UserProfileStorage.save(profile)
    }
}

#Preview {
    Profile()
}
