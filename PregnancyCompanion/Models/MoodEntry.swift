import Foundation
import SwiftData

@Model
final class MoodEntry {
    var id: UUID
    var date: Date
    var discomfort: Int // 1-5 scale (1 = very uncomfortable, 5 = very comfortable)
    var sleep: Int // 1-5 scale
    var diet: Int // 1-5 scale (how satisfied with diet)
    var mood: Int // 1-5 scale (general mood)
    var productivity: Int // 1-5 scale
    var notes: String?
    
    init(discomfort: Int, sleep: Int, diet: Int, mood: Int, productivity: Int, notes: String? = nil) {
        self.id = UUID()
        self.date = Date()
        self.discomfort = discomfort
        self.sleep = sleep
        self.diet = diet
        self.mood = mood
        self.productivity = productivity
        self.notes = notes
    }
    
    /// Check if this entry is from today
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    /// Average mood score
    var averageScore: Double {
        Double(discomfort + sleep + diet + mood + productivity) / 5.0
    }
    
    /// Overall mood description
    var overallMoodDescription: String {
        let avg = averageScore
        switch avg {
        case 4.5...5.0: return "Wonderful"
        case 3.5..<4.5: return "Good"
        case 2.5..<3.5: return "Okay"
        case 1.5..<2.5: return "Not great"
        default: return "Tough day"
        }
    }
    
    /// Formatted date
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Mood Emoji Helper
enum MoodLevel: Int, CaseIterable {
    case verySad = 1
    case sad = 2
    case neutral = 3
    case happy = 4
    case veryHappy = 5
    
    var emoji: String {
        switch self {
        case .verySad: return "😢"
        case .sad: return "😔"
        case .neutral: return "😐"
        case .happy: return "🙂"
        case .veryHappy: return "😄"
        }
    }
    
    var description: String {
        switch self {
        case .verySad: return "Very Bad"
        case .sad: return "Bad"
        case .neutral: return "Okay"
        case .happy: return "Good"
        case .veryHappy: return "Great"
        }
    }
}

// MARK: - Mood Categories
enum MoodCategory: String, CaseIterable {
    case discomfort = "Comfort Level"
    case sleep = "Sleep Quality"
    case diet = "Diet Satisfaction"
    case mood = "General Mood"
    case productivity = "Energy Level"
    
    var icon: String {
        switch self {
        case .discomfort: return "figure.walk"
        case .sleep: return "moon.zzz.fill"
        case .diet: return "fork.knife"
        case .mood: return "heart.fill"
        case .productivity: return "bolt.fill"
        }
    }
}


