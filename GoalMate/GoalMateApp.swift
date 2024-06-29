//
//  GoalMateApp.swift
//  GoalMate
//
//  Created by MUQUEET MOHSEN CHOWDHURY on 28/6/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct GoalMateApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isLoggedIn = false
    @State private var showSignUp = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainView(isLoggedIn: $isLoggedIn)
            } else {
                if showSignUp {
                    SignUpView(isLoggedIn: $isLoggedIn, showSignUp: $showSignUp)
                } else {
                    LoginView(isLoggedIn: $isLoggedIn, showSignUp: $showSignUp)
                }
            }
        }
    }
}

