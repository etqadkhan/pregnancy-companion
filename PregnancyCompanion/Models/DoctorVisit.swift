import Foundation
import SwiftData

@Model
final class DoctorVisit {
    var id: UUID
    var date: Date
    var weight: Double? // Weight at the visit (in kg)
    var notes: String // What the doctor said
    var injections: String? // Any injections administered
    var bloodPressure: String? // Optional BP reading
    var createdAt: Date
    
    init(date: Date, weight: Double? = nil, notes: String = "", injections: String? = nil, bloodPressure: String? = nil) {
        self.id = UUID()
        self.date = date
        self.weight = weight
        self.notes = notes
        self.injections = injections
        self.bloodPressure = bloodPressure
        self.createdAt = Date()
    }
    
    /// Formatted date string
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    /// Check if visit is upcoming
    var isUpcoming: Bool {
        date > Date()
    }
    
    /// Check if visit is today
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
}


