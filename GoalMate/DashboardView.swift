import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct DashboardView: View {
    @Binding var isLoggedIn: Bool
    @State private var showAddGoalView = false
    @State private var activeGoals: [Goal] = []
    @State private var completedGoals: [Goal] = []
    @State private var trackingRequests: [Goal] = []
    @State private var trackedRequests: [Goal] = []
    private let db = Firestore.firestore()
    @State private var listener: ListenerRegistration?

    var body: some View {
            NavigationView {
                GeometryReader { geometry in
                    VStack {
                        List {
                            Section(header: Text("Active Goals")) {
                                ForEach(activeGoals) { goal in
                                    NavigationLink(destination: GoalDetailView(goal: goal)) {
                                        Text(goal.title)
                                    }
                                }
                            }

                            Section(header: Text("Completed Goals")) {
                                ForEach(completedGoals) { goal in
                                    Text(goal.title)
                                }
                            }

                            Section(header: Text("Tracking Requests")) {
                                ForEach(trackingRequests) { request in
                                    NavigationLink(destination: TrackingDetailView(goal: request)) {
                                        Text(request.title)
                                    }
                                }
                            }

                            Section(header: Text("Requests Tracked")) {
                                ForEach(trackedRequests) { request in
                                    Text(request.title)
                                }
                            }
                        }
                        .listStyle(GroupedListStyle())
                        .frame(width: geometry.size.width)
                        .padding(.top, -50)
                    }
                }
                .navigationBarTitle("Dashboard", displayMode: .inline)
                .navigationBarItems(leading: Button(action: logout) {
                    Text("Logout")
                        .foregroundColor(.red)
                }, trailing: Button(action: {
                    showAddGoalView.toggle()
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showAddGoalView) {
                    AddGoalView()
                }
                .onAppear {
                    fetchGoals()
                    setupListener()
                }
                .onDisappear {
                    listener?.remove()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }

    private func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }

    private func fetchGoals() {
        Task {
            do {
                if let userId = Auth.auth().currentUser?.uid {
                    self.activeGoals = try await FirebaseService.shared.fetchUserGoals(userId: userId)
                    self.completedGoals = try await FirebaseService.shared.fetchCompletedGoals(userId: userId)
                    if let email = Auth.auth().currentUser?.email {
                        self.trackingRequests = try await FirebaseService.shared.fetchTrackingRequests(trackingEmail: email)
                        self.trackedRequests = try await FirebaseService.shared.fetchTrackedRequests(trackingEmail: email)
                    }
                }
            } catch {
                print("Error fetching goals: \(error)")
            }
        }
    }

    private func setupListener() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        listener = db.collection("goals")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }

                let documents = snapshot.documents
                activeGoals = documents.filter { !($0.data()["isCompleted"] as? Bool ?? false) }.map { document in
                    let data = document.data()
                    return Goal(
                        id: document.documentID,
                        title: data["title"] as? String ?? "",
                        type: data["type"] as? String ?? "",
                        details: data["details"] as? String ?? "",
                        trackerEmail: data["trackerEmail"] as? String ?? "",
                        amount: data["amount"] as? Double ?? 0.0,
                        isActive: data["isActive"] as? Bool ?? false,
                        userId: data["userId"] as? String ?? "",
                        isCompletedByTracker: data["isCompletedByTracker"] as? Bool ?? false,
                        isCompleted: data["isCompleted"] as? Bool ?? false,
                        progressDetails: data["progressDetails"] as? [String] ?? [],
                        imageURL: data["imageURL"] as? String ?? ""
                    )
                }

                completedGoals = documents.filter { $0.data()["isCompleted"] as? Bool ?? false }.map { document in
                    let data = document.data()
                    return Goal(
                        id: document.documentID,
                        title: data["title"] as? String ?? "",
                        type: data["type"] as? String ?? "",
                        details: data["details"] as? String ?? "",
                        trackerEmail: data["trackerEmail"] as? String ?? "",
                        amount: data["amount"] as? Double ?? 0.0,
                        isActive: data["isActive"] as? Bool ?? false,
                        userId: data["userId"] as? String ?? "",
                        isCompletedByTracker: data["isCompletedByTracker"] as? Bool ?? false,
                        isCompleted: data["isCompleted"] as? Bool ?? false,
                        progressDetails: data["progressDetails"] as? [String] ?? [],
                        imageURL: data["imageURL"] as? String ?? ""
                    )
                }
            }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(isLoggedIn: .constant(true))
    }
}
