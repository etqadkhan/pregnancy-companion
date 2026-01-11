import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String
    var age: Int
    var weight: Double // in kg
    var dueDate: Date
    var createdAt: Date
    
    init(name: String, age: Int, weight: Double, dueDate: Date) {
        self.name = name
        self.age = age
        self.weight = weight
        self.dueDate = dueDate
        self.createdAt = Date()
    }
    
    /// Calculate current pregnancy week based on due date
    /// Pregnancy is typically 40 weeks, so we calculate backwards from due date
    var currentWeek: Int {
        let calendar = Calendar.current
        let today = Date()
        
        // Calculate conception date (40 weeks before due date)
        guard let conceptionDate = calendar.date(byAdding: .weekOfYear, value: -40, to: dueDate) else {
            return 0
        }
        
        // Calculate weeks since conception
        let components = calendar.dateComponents([.weekOfYear], from: conceptionDate, to: today)
        let weeks = components.weekOfYear ?? 0
        
        // Clamp between 1 and 42
        return max(1, min(42, weeks))
    }
    
    /// Days remaining until due date
    var daysRemaining: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: dueDate)
        return max(0, components.day ?? 0)
    }
    
    /// Progress through pregnancy (0.0 to 1.0)
    var progress: Double {
        return Double(currentWeek) / 40.0
    }
}


