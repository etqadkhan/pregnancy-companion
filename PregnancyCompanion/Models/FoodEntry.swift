import Foundation
import SwiftData

@Model
final class FoodEntry {
    var id: UUID
    var foodName: String
    var protein: Double // in grams
    var fiber: Double // in grams
    var calories: Double
    var timestamp: Date
    var isManualEntry: Bool // true if user manually entered nutrition, false if from AI
    var notes: String?
    
    init(foodName: String, protein: Double = 0, fiber: Double = 0, calories: Double = 0, isManualEntry: Bool = false, notes: String? = nil) {
        self.id = UUID()
        self.foodName = foodName
        self.protein = protein
        self.fiber = fiber
        self.calories = calories
        self.timestamp = Date()
        self.isManualEntry = isManualEntry
        self.notes = notes
    }
    
    /// Check if this entry is from today
    var isToday: Bool {
        Calendar.current.isDateInToday(timestamp)
    }
}

// MARK: - Helper for daily totals
extension Array where Element == FoodEntry {
    var totalProtein: Double {
        reduce(0) { $0 + $1.protein }
    }
    
    var totalFiber: Double {
        reduce(0) { $0 + $1.fiber }
    }
    
    var totalCalories: Double {
        reduce(0) { $0 + $1.calories }
    }
    
    func entriesForToday() -> [FoodEntry] {
        filter { $0.isToday }
    }
}


