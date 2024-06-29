import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import UIKit

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()

    func addGoal(_ goal: Goal) async throws {
        try await db.collection("goals").document(goal.id).setData([
            "title": goal.title,
            "type": goal.type,
            "details": goal.details,
            "trackerEmail": goal.trackerEmail,
            "amount": goal.amount,
            "isActive": goal.isActive,
            "userId": goal.userId,
            "isCompletedByTracker": goal.isCompletedByTracker,
            "isCompleted": goal.isCompleted,
            "progressDetails": goal.progressDetails ?? [],
            "imageURL": goal.imageURL ?? ""
        ])
    }

    func updateProgress(for goalId: String, progress: String, image: UIImage?) async throws {
        let goalRef = db.collection("goals").document(goalId)
        let document = try await goalRef.getDocument()
        var progressDetails = document.data()?["progressDetails"] as? [String] ?? []
        progressDetails.append(progress)

        var data: [String: Any] = ["progressDetails": progressDetails]

        if let image = image {
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("images/\(imageName).jpg")
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

            _ = try await storageRef.putDataAsync(imageData)
            let imageURL = try await storageRef.downloadURL()
            data["imageURL"] = imageURL.absoluteString
        }

        try await goalRef.updateData(data)
    }

    func fetchUserGoals(userId: String) async throws -> [Goal] {
        let snapshot = try await db.collection("goals").whereField("userId", isEqualTo: userId).whereField("isCompleted", isEqualTo: false).getDocuments()
        return snapshot.documents.map { document in
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

    func fetchCompletedGoals(userId: String) async throws -> [Goal] {
        let snapshot = try await db.collection("goals").whereField("userId", isEqualTo: userId).whereField("isCompleted", isEqualTo: true).getDocuments()
        return snapshot.documents.map { document in
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

    func fetchTrackingRequests(trackingEmail: String) async throws -> [Goal] {
        let snapshot = try await db.collection("goals").whereField("trackerEmail", isEqualTo: trackingEmail).whereField("isCompletedByTracker", isEqualTo: false).getDocuments()
        return snapshot.documents.map { document in
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

    func fetchTrackedRequests(trackingEmail: String) async throws -> [Goal] {
        let snapshot = try await db.collection("goals").whereField("trackerEmail", isEqualTo: trackingEmail).whereField("isCompletedByTracker", isEqualTo: true).getDocuments()
        return snapshot.documents.map { document in
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

    func markGoalAsCompletedByTracker(goalId: String) async throws {
        try await db.collection("goals").document(goalId).updateData([
            "isCompletedByTracker": true,
            "isCompleted": true
        ])
    }
    func fetchGoalById(_ goalId: String) async throws -> Goal {
            let document = try await db.collection("goals").document(goalId).getDocument()
            let data = document.data()!
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
