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

    let goalTypes = ["Fitness", "Nutrition", "Mindfulness", "Other"]

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
                    HStack {
                        Image(systemName: "textformat")
                            .foregroundColor(.gray)
                        TextField("Title", text: $title)
                            .padding(.leading, 5)
                    }
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.gray)
                        TextField("Details", text: $details)
                            .padding(.leading, 5)
                    }
                }

                Section(header: Text("Tracker Information")) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Track by Email", text: $trackerEmail)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textInputAutocapitalization(.never)
                            .padding(.leading, 5)
                    }
                    HStack {
                        Image(systemName: "dollarsign.circle")
                            .foregroundColor(.gray)
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                            .padding(.leading, 5)
                    }
                }

                Button(action: addGoal) {
                    Text("Add Goal")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .navigationBarTitle("Add a Goal", displayMode: .inline)
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

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView()
    }
}
