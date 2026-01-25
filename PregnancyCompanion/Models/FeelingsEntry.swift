import Foundation
import SwiftData

@Model
final class FeelingsEntry {
    var id: UUID
    var date: Date
    
    // Pregnancy-specific feeling questions (1-5 scale)
    var howFeeling: Int // How are you feeling today?
    var feelBump: Int // Could you feel the bump today?
    var connectedToBaby: Int // How connected do you feel to your baby?
    var feelSupported: Int // How supported do you feel?
    var excitedAboutJourney: Int // How excited are you about your pregnancy journey?
    
    // Journal entry (free text)
    var journalText: String?
    
    init(
        howFeeling: Int = 3,
        feelBump: Int = 3,
        connectedToBaby: Int = 3,
        feelSupported: Int = 3,
        excitedAboutJourney: Int = 3,
        journalText: String? = nil
    ) {
        self.id = UUID()
        self.date = Date()
        self.howFeeling = howFeeling
        self.feelBump = feelBump
        self.connectedToBaby = connectedToBaby
        self.feelSupported = feelSupported
        self.excitedAboutJourney = excitedAboutJourney
        self.journalText = journalText
    }
    
    /// Check if this entry is from today
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    /// Average feelings score
    var averageScore: Double {
        Double(howFeeling + feelBump + connectedToBaby + feelSupported + excitedAboutJourney) / 5.0
    }
    
    /// Formatted date
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    /// Short date string for list views
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Feelings Question Helper
enum FeelingsQuestion: String, CaseIterable {
    case howFeeling = "How are you feeling today?"
    case feelBump = "Could you feel the bump today?"
    case connectedToBaby = "How connected do you feel to your baby?"
    case feelSupported = "How supported do you feel?"
    case excitedAboutJourney = "How excited are you about your pregnancy journey?"
    
    var icon: String {
        switch self {
        case .howFeeling: return "heart.fill"
        case .feelBump: return "hand.point.up.left.fill"
        case .connectedToBaby: return "heart.circle.fill"
        case .feelSupported: return "person.2.fill"
        case .excitedAboutJourney: return "sparkles"
        }
    }
    
    var subtitle: String {
        switch self {
        case .howFeeling: return "Take a moment to check in with yourself"
        case .feelBump: return "Any movements or sensations?"
        case .connectedToBaby: return "Your bond with your little one"
        case .feelSupported: return "By family, friends, and loved ones"
        case .excitedAboutJourney: return "Looking forward to what's ahead"
        }
    }
}

// MARK: - Feelings Level Helper (reusing MoodLevel for consistency)
// Using the same MoodLevel enum from MoodEntry for consistency
