//
//  MainTabView.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI

struct MainTabView: View {

    enum Tab {
        case home
        case scan
        case explore
        case profile
    }

    private let usesDemoScanMenu: Bool

    @State private var selectedTab: Tab

    init(
        initialTab: Tab = .home,
        usesDemoScanMenu: Bool = true
    ) {
        self.usesDemoScanMenu = usesDemoScanMenu
        _selectedTab = State(initialValue: initialTab)
    }

    var body: some View {

        TabView(selection: $selectedTab) {

            Home()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)

            ScanMenuView(usesDemoMenu: usesDemoScanMenu)
                .tabItem {
                    Label("Scan", systemImage: "document.viewfinder.fill")
                }
                .tag(Tab.scan)

            Explore()
                .tabItem {
                    Label("Explore", systemImage: "location.magnifyingglass")
                }
                .tag(Tab.explore)

            Profile()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(OliveTheme.primaryGreen)
    }
}

#Preview {
    MainTabView()
}

#Preview("Scan Tab") {
    MainTabView(initialTab: .scan)
}
