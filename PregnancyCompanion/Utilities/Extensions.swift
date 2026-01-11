import SwiftUI

// MARK: - Color Palette
extension Color {
    // Primary: Soft Lavender
    static let primaryPastel = Color(red: 230/255, green: 224/255, blue: 248/255)
    
    // Secondary: Blush Pink
    static let secondaryPastel = Color(red: 255/255, green: 228/255, blue: 230/255)
    
    // Accent: Sage Green
    static let accentPastel = Color(red: 209/255, green: 231/255, blue: 221/255)
    
    // Background: Warm White
    static let backgroundPastel = Color(red: 254/255, green: 254/255, blue: 254/255)
    
    // Text: Soft Charcoal
    static let textPrimary = Color(red: 74/255, green: 74/255, blue: 74/255)
    
    // Additional accent colors
    static let softPeach = Color(red: 255/255, green: 218/255, blue: 193/255)
    static let softBlue = Color(red: 214/255, green: 234/255, blue: 248/255)
}

// MARK: - Date Extensions
extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func weeksUntil(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear], from: self, to: date)
        return components.weekOfYear ?? 0
    }
    
    func weeksSince(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear], from: date, to: self)
        return components.weekOfYear ?? 0
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(.system(.body, design: .rounded, weight: .semibold))
            .foregroundColor(.textPrimary)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color.primaryPastel)
            .cornerRadius(12)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(.system(.body, design: .rounded, weight: .medium))
            .foregroundColor(.textPrimary)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.secondaryPastel)
            .cornerRadius(10)
    }
}

// MARK: - String Extensions
extension String {
    func isNotEmpty() -> Bool {
        !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}


