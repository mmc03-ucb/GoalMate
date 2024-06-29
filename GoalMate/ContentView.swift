import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var showSignUp = false

    var body: some View {
        Group {
            if isLoggedIn {
                DashboardView(isLoggedIn: $isLoggedIn)
            } else {
                LoginView(isLoggedIn: $isLoggedIn, showSignUp: $showSignUp)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
