//
//  PermissionCard.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct PermissionCard: View {

    let icon: String
    let title: String
    let description: String
    let isEnabled: Bool

    var body: some View {

        HStack(alignment: .top, spacing: 16) {

            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(OliveTheme.primaryGreen)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 6) {

                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(
                systemName: isEnabled
                ? "checkmark.circle.fill"
                : "circle"
            )
            .font(.title3)
            .foregroundStyle(
                isEnabled
                ? OliveTheme.primaryGreen
                : .gray.opacity(0.4)
            )
        }
        .padding()
        .background(.white)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
    }
}
