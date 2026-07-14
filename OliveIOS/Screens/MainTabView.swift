//
//  MainTabView.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct MainTabView: View {

    var body: some View {

        TabView {

            Home()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ScanMenuView()
                .tabItem {
                    Label("Scan", systemImage: "camera.fill")
                }

            Explore()
                .tabItem {
                    Label("Explore", systemImage: "map.fill")
                }

            Profile()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
