//
//  Item.swift
//  GoalMate
//
//  Created by MUQUEET MOHSEN CHOWDHURY on 28/6/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
