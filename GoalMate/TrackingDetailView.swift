import SwiftUI

struct TrackingDetailView: View {
    let goal: Goal
    @State private var newProgressDetail: String = ""
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var imageURL: URL?
    @State private var progressDetails: [String] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(goal.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                if let imageURL = imageURL {
                    AsyncImage(url: imageURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .padding()
                        } else if phase.error != nil {
                            Text("Failed to load image")
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            ProgressView()
                                .frame(height: 200)
                                .padding()
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Progress:")
                        .font(.headline)
                    if !progressDetails.isEmpty {
                        ForEach(progressDetails, id: \.self) { detail in
                            Text("• \(detail)")
                                .padding(.leading)
                        }
                    }
                }
                .padding(.horizontal)

                Button(action: markAsComplete) {
                    Text("Mark as Complete")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .onAppear {
            progressDetails = goal.progressDetails ?? []
            if let imageURLString = goal.imageURL {
                imageURL = URL(string: imageURLString)
            }
        }
    }

    private func markAsComplete() {
        Task {
            do {
                try await FirebaseService.shared.markGoalAsCompletedByTracker(goalId: goal.id)
                // Fetch the updated goal to get the latest imageURL and progress details
                let updatedGoal = try await FirebaseService.shared.fetchGoalById(goal.id)
                progressDetails = updatedGoal.progressDetails ?? []
                if let imageURLString = updatedGoal.imageURL {
                    imageURL = URL(string: imageURLString)
                }
                newProgressDetail = "" // Clear the input bar after submitting progress
                selectedImage = nil // Clear the selected image
            } catch {
                print("Error marking goal as complete: \(error)")
            }
        }
    }
}

struct TrackingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingDetailView(goal: Goal(id: "1", title: "Test Goal", type: "Fitness", details: "Some details", trackerEmail: "test@example.com", amount: 100.0, isActive: true, userId: "user1", isCompletedByTracker: false, isCompleted: false, progressDetails: ["Initial progress"], imageURL: nil))
    }
}
