import SwiftUI

struct GoalDetailView: View {
    let goal: Goal
    @State private var newProgressDetail: String = ""
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var imageURL: URL?
    @State private var progressDetails: [String] = []

    var body: some View {
        VStack {
            Text(goal.title)
                .font(.largeTitle)
                .padding()

            if let imageURL = imageURL {
                AsyncImage(url: imageURL) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
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

            VStack(alignment: .leading) {
                Text("Progress Details:")
                    .font(.headline)
                    .padding(.top)
                if !progressDetails.isEmpty {
                    ForEach(progressDetails, id: \.self) { detail in
                        Text("• \(detail)")
                            .padding(.leading)
                    }
                }
            }

            TextField("Add Progress Details", text: $newProgressDetail)
                .padding()
                .border(Color.gray, width: 1)
                .padding()

            Button(action: {
                showImagePicker.toggle()
            }) {
                Text("Attach Picture")
            }
            .padding()

            Button(action: submitProgress) {
                Text("Submit Progress")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
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

    private func submitProgress() {
        Task {
            do {
                try await FirebaseService.shared.updateProgress(for: goal.id, progress: newProgressDetail, image: selectedImage)
                // Fetch the updated goal to get the latest imageURL and progress details
                let updatedGoal = try await FirebaseService.shared.fetchGoalById(goal.id)
                progressDetails = updatedGoal.progressDetails ?? []
                if let imageURLString = updatedGoal.imageURL {
                    imageURL = URL(string: imageURLString)
                }
                newProgressDetail = "" // Clear the input bar after submitting progress
                selectedImage = nil // Clear the selected image
            } catch {
                print("Error updating progress: \(error)")
            }
        }
    }
}