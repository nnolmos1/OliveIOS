import SwiftUI

struct SelectionCard: View {

    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 16) {

                Image(systemName: icon)
                    .font(.title3)

                Text(title)
                    .fontWeight(.medium)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                }
            }
            .foregroundStyle(
                isSelected
                ? .white
                : Color(
                    red: 0.15,
                    green: 0.23,
                    blue: 0.35
                )
            )
            .padding()
            .frame(maxWidth: .infinity)
            .background {

                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        isSelected
                        ? Color(
                            red: 0.42,
                            green: 0.58,
                            blue: 0.46
                        )
                        : .white
                    )
            }
            .overlay {

                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isSelected
                        ? .clear
                        : Color.gray.opacity(0.15),
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
    }
}
