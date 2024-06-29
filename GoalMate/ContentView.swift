import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isLoggedIn = false

    var body: some View {
        Group {
            if isLoggedIn {
                DashboardView(isLoggedIn: $isLoggedIn)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}

#Preview {
    ContentView()
}
