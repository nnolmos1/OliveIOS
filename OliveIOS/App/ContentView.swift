//
//  ContentView.swift
//  Olive
//
//  Created by SandboxLab on 7/1/26.
//
import SwiftUI
struct ContentView: View {
    var body: some View {
        
        
        TabView {
            Home()
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            Scan()
                .tabItem{
                    Image(systemName: "plus.viewfinder")
                    Text("Scan")
                }
            Explore()
                .tabItem{
                    Image(systemName: "location.magnifyingglass")
                    Text("Explore")
                }
            Profile()
                .tabItem{
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    
    }
}
#Preview {
    ContentView()
}
