//
//  Home.swift
//  Olive
//
//  Created by SandboxLab on 7/1/26.
//
import SwiftUI
struct Home: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    welcomeSection
                    quickActionsSection
                    askOliveSection
                    profileSummarySection
                }
                .padding()
            }
            .navigationTitle("Olive")
        }
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Good Morning, User!")
                .font(.title)
                .fontWeight(.bold)
            Text("Olive helps you make confident food decisions.")
                .foregroundStyle(.secondary)
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            HStack(spacing: 12) {
                actionCard(
                    title: "Scan Menu",
                    icon: "camera.fill"
                )
                actionCard(
                    title: "Explore",
                    icon: "magnifyingglass"
                )
            }
        }
    }
    
    private func actionCard(
        title: String,
        icon: String
    ) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var askOliveSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ask Olive")
                .font(.headline)
            VStack(alignment: .leading, spacing: 8) {
                Text("Your AI nutrition accessibility assistant")
                    .font(.subheadline)
                Text("Can I eat here?")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
    }
    
    private var profileSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Profile")
                .font(.headline)
            VStack(alignment: .leading, spacing: 10) {
                Label(
                    "Type 2 Diabetes",
                    systemImage: "heart.text.square"
                )
                Label(
                    "Hypertension",
                    systemImage: "heart.text.square"
                )
                Label(
                    "Peanut Allergy",
                    systemImage: "exclamationmark.shield"
                )
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
    }
}
#Preview {
    Home()
}
