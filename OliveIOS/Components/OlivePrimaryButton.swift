import SwiftUI

struct OlivePrimaryButton: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        Color(
                            red: 0.15,
                            green: 0.23,
                            blue: 0.35
                        )
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.15),
                       value: configuration.isPressed)
    }
}
