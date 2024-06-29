//
//  MainView.swift
//  GoalMate
//
//  Created by MUQUEET MOHSEN CHOWDHURY on 29/6/24.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            Text("Main Page")
                .font(.largeTitle)
                .padding()
            
            Button(action: logout) {
                Text("Logout")
                    .font(.headline)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            print("User logged out")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(isLoggedIn: .constant(true))
    }
}
