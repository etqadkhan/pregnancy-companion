import Foundation
import SwiftData

@Model
final class WeightEntry {
    var id: UUID
    var weight: Double // in kg
    var timestamp: Date
    var notes: String?
    
    init(weight: Double, notes: String? = nil) {
        self.id = UUID()
        self.weight = weight
        self.timestamp = Date()
        self.notes = notes
    }
    
    /// Formatted weight string
    var weightString: String {
        String(format: "%.1f kg", weight)
    }
    
    /// Formatted date string
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }
    
    /// Short date string for charts
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: timestamp)
    }
}

// MARK: - Helper for weight analysis
extension Array where Element == WeightEntry {
    /// Get the most recent weight entry
    var mostRecent: WeightEntry? {
        self.sorted { $0.timestamp > $1.timestamp }.first
    }
    
    /// Get the oldest weight entry
    var oldest: WeightEntry? {
        self.sorted { $0.timestamp < $1.timestamp }.first
    }
    
    /// Calculate total weight gain from first entry
    var totalWeightChange: Double? {
        guard let first = oldest, let last = mostRecent else { return nil }
        return last.weight - first.weight
    }
    
    /// Get entries sorted by date (newest first)
    var sortedByDate: [WeightEntry] {
        self.sorted { $0.timestamp > $1.timestamp }
    }
    
    /// Get entries for a specific week
    func entries(forWeek weekStart: Date) -> [WeightEntry] {
        let calendar = Calendar.current
        guard let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else {
            return []
        }
        return self.filter { $0.timestamp >= weekStart && $0.timestamp < weekEnd }
    }
}
