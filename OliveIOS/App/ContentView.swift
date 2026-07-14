//
//  ContentView.swift
//  Olive
//
//  Created by SandboxLab on 7/1/26.
//
import SwiftUI

struct ContentView: View {

    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false
    

    var body: some View {
        
        Group {
            if hasCompletedOnboarding {
                
                MainTabView()
                
            } else {
                
                OnboardingFlowView()
            }
        }
// Uncomment for testing purposes
//        .onAppear {
//            hasCompletedOnboarding = false
//        }
    }
}

#Preview {
    ContentView()
}
