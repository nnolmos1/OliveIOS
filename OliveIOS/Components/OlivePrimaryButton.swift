import SwiftUI

struct OlivePrimaryButton: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {

        configuration.label
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(OliveTheme.primaryGreen)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.15),
                       value: configuration.isPressed)
    }
}
