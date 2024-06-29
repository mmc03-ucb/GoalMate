//
//  GoalView.swift
//  GoalMate
//
//  Created by MUQUEET MOHSEN CHOWDHURY on 29/6/24.
//

import SwiftUI
import FirebaseAuth

struct AddGoalView: View {
    @State private var selectedType: String = ""
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var trackerEmail: String = ""
    @State private var amount: String = ""
    @Environment(\.presentationMode) var presentationMode

    let goalTypes = ["Fitness", "Nutrition", "Mindfulness"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Type")) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(goalTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Goal Details")) {
                    TextField("Title", text: $title)
                    TextField("Details", text: $details)
                }

                Section(header: Text("Tracker Information")) {
                    TextField("Track by Email", text: $trackerEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textInputAutocapitalization(.never)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }

                Button(action: addGoal) {
                    Text("Add Goal")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationBarTitle("Add a Goal")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func addGoal() {
        guard let amount = Double(amount) else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let newGoal = Goal(
            id: UUID().uuidString,
            title: title,
            type: selectedType,
            details: details,
            trackerEmail: trackerEmail.lowercased(), // Ensure email is stored in lowercase
            amount: amount,
            isActive: false,
            userId: userId,
            isCompletedByTracker: false,
            isCompleted: false
        )

        Task {
            do {
                try await FirebaseService.shared.addGoal(newGoal)
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Error adding goal: \(error)")
            }
        }
    }
}
