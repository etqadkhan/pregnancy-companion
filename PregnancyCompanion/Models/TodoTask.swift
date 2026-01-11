import Foundation
import SwiftData

@Model
final class TodoTask {
    var id: UUID
    var title: String
    var reminderTime: Date // The time of day for the reminder
    var isCompleted: Bool
    var lastCompletedDate: Date? // Track when it was last completed (for daily reset)
    var lastNudgeTime: Date? // Track last nudge for hourly re-reminders
    var createdAt: Date
    var isActive: Bool // Whether this task is active/enabled
    
    init(title: String, reminderTime: Date, isActive: Bool = true) {
        self.id = UUID()
        self.title = title
        self.reminderTime = reminderTime
        self.isCompleted = false
        self.lastCompletedDate = nil
        self.lastNudgeTime = nil
        self.createdAt = Date()
        self.isActive = isActive
    }
    
    /// Check if task is completed for today
    var isCompletedToday: Bool {
        guard let lastCompleted = lastCompletedDate else { return false }
        return Calendar.current.isDateInToday(lastCompleted)
    }
    
    /// Mark task as completed for today
    func markCompleted() {
        isCompleted = true
        lastCompletedDate = Date()
    }
    
    /// Reset completion status (called at start of new day)
    func resetForNewDay() {
        if let lastCompleted = lastCompletedDate,
           !Calendar.current.isDateInToday(lastCompleted) {
            isCompleted = false
        }
    }
    
    /// Check if task needs a nudge (past reminder time and not completed)
    var needsNudge: Bool {
        guard isActive && !isCompletedToday else { return false }
        
        let now = Date()
        let calendar = Calendar.current
        
        // Get today's reminder time
        let todayReminder = calendar.date(
            bySettingHour: calendar.component(.hour, from: reminderTime),
            minute: calendar.component(.minute, from: reminderTime),
            second: 0,
            of: now
        ) ?? now
        
        return now > todayReminder
    }
    
    /// Get the hour and minute components for display
    var reminderTimeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: reminderTime)
    }
}


