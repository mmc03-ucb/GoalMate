//
//  Models.swift
//  GoalMate
//
//  Created by MUQUEET MOHSEN CHOWDHURY on 29/6/24.
//

import Foundation

struct Goal: Identifiable {
    let id: String
    let title: String
    let type: String
    let details: String
    let trackerEmail: String
    let amount: Double
    let isActive: Bool
    let userId: String
    var isCompletedByTracker: Bool
    var isCompleted: Bool
    var progressDetails: [String]?
    var imageURL: String?
}




struct GoalRequest: Identifiable {
    let id: String
    let title: String
    let type: String
    let details: String
    let requesterEmail: String
    let amount: Double
}

