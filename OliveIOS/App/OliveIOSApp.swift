//
//  OliveIOSApp.swift
//  OliveIOS
//
//  Created by SandboxLab on 7/13/26.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        #if DEBUG
        AppCheck.setAppCheckProviderFactory(
            AppCheckDebugProviderFactory()
        )
        #endif

        FirebaseApp.configure()
        return true
    }
}

@main
struct OliveIOS: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
