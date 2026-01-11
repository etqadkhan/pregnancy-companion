import SwiftUI
import SwiftData

struct MoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MoodEntry.date, order: .reverse) private var moodEntries: [MoodEntry]
    
    @State private var showCheckIn = false
    
    private var todayEntry: MoodEntry? {
        moodEntries.first { $0.isToday }
    }
    
    private var recentEntries: [MoodEntry] {
        Array(moodEntries.prefix(7))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Today's Check-in Status
                    todayStatusCard
                    
                    // Quick Stats
                    if !moodEntries.isEmpty {
                        statsCard
                    }
                    
                    // Recent History
                    if !recentEntries.isEmpty {
                        historySection
                    }
                }
                .padding()
            }
            .background(Color.backgroundPastel)
            .navigationTitle("Mood")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showCheckIn) {
                MoodCheckInSheet(existingEntry: todayEntry)
            }
        }
    }
    
    // MARK: - Today Status Card
    private var todayStatusCard: some View {
        VStack(spacing: 16) {
            if let entry = todayEntry {
                // Already checked in today
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Today's Check-in")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        Text(entry.overallMoodDescription)
                            .font(.system(.title3, design: .rounded, weight: .medium))
                            .foregroundColor(.textPrimary.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Mood average display
                    ZStack {
                        Circle()
                            .fill(moodColor(for: entry.averageScore))
                            .frame(width: 60, height: 60)
                        
                        Text(moodEmoji(for: entry.averageScore))
                            .font(.system(size: 28))
                    }
                }
                
                Button(action: { showCheckIn = true }) {
                    Text("Update Check-in")
                        .secondaryButtonStyle()
                }
            } else {
                // No check-in today
                VStack(spacing: 16) {
                    Image(systemName: "face.smiling")
                        .font(.system(size: 48))
                        .foregroundColor(.primaryPastel)
                    
                    Text("How are you feeling today?")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    Text("Take a moment to check in with yourself")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.6))
                    
                    Button(action: { showCheckIn = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Check In")
                        }
                        .primaryButtonStyle()
                    }
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Stats Card
    private var statsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            HStack(spacing: 12) {
                ForEach(recentEntries.reversed(), id: \.id) { entry in
                    VStack(spacing: 4) {
                        Text(moodEmoji(for: entry.averageScore))
                            .font(.title2)
                        
                        Text(dayAbbreviation(for: entry.date))
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.textPrimary.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - History Section
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Entries")
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundColor(.textPrimary)
                .padding(.leading, 4)
            
            VStack(spacing: 8) {
                ForEach(recentEntries, id: \.id) { entry in
                    MoodHistoryRow(entry: entry)
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func moodEmoji(for score: Double) -> String {
        switch score {
        case 4.5...5.0: return "😄"
        case 3.5..<4.5: return "🙂"
        case 2.5..<3.5: return "😐"
        case 1.5..<2.5: return "😔"
        default: return "😢"
        }
    }
    
    private func moodColor(for score: Double) -> Color {
        switch score {
        case 4.0...5.0: return Color.accentPastel
        case 3.0..<4.0: return Color.primaryPastel
        case 2.0..<3.0: return Color.softPeach
        default: return Color.secondaryPastel
        }
    }
    
    private func dayAbbreviation(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

// MARK: - Mood History Row
struct MoodHistoryRow: View {
    let entry: MoodEntry
    
    var body: some View {
        HStack(spacing: 16) {
            Text(moodEmoji(for: entry.averageScore))
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.dateString)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Text(entry.overallMoodDescription)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.6))
            }
            
            Spacer()
            
            // Mini indicators
            HStack(spacing: 8) {
                miniIndicator(value: entry.mood, icon: "heart.fill")
                miniIndicator(value: entry.sleep, icon: "moon.fill")
                miniIndicator(value: entry.discomfort, icon: "figure.walk")
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
    
    private func miniIndicator(value: Int, icon: String) -> some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text("\(value)")
                .font(.system(size: 10, design: .rounded))
        }
        .foregroundColor(.textPrimary.opacity(0.5))
    }
    
    private func moodEmoji(for score: Double) -> String {
        switch score {
        case 4.5...5.0: return "😄"
        case 3.5..<4.5: return "🙂"
        case 2.5..<3.5: return "😐"
        case 1.5..<2.5: return "😔"
        default: return "😢"
        }
    }
}

// MARK: - Mood Check In Sheet
struct MoodCheckInSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let existingEntry: MoodEntry?
    
    @State private var discomfort: Int = 3
    @State private var sleep: Int = 3
    @State private var diet: Int = 3
    @State private var mood: Int = 3
    @State private var productivity: Int = 3
    @State private var notes: String = ""
    
    init(existingEntry: MoodEntry?) {
        self.existingEntry = existingEntry
        if let entry = existingEntry {
            _discomfort = State(initialValue: entry.discomfort)
            _sleep = State(initialValue: entry.sleep)
            _diet = State(initialValue: entry.diet)
            _mood = State(initialValue: entry.mood)
            _productivity = State(initialValue: entry.productivity)
            _notes = State(initialValue: entry.notes ?? "")
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("How are you feeling?")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .padding(.top)
                    
                    // Mood questions
                    VStack(spacing: 20) {
                        moodQuestion(
                            title: "Comfort Level",
                            subtitle: "How comfortable do you feel physically?",
                            icon: "figure.walk",
                            value: $discomfort
                        )
                        
                        moodQuestion(
                            title: "Sleep Quality",
                            subtitle: "How well did you sleep?",
                            icon: "moon.zzz.fill",
                            value: $sleep
                        )
                        
                        moodQuestion(
                            title: "Diet Satisfaction",
                            subtitle: "How satisfied are you with what you ate?",
                            icon: "fork.knife",
                            value: $diet
                        )
                        
                        moodQuestion(
                            title: "General Mood",
                            subtitle: "How is your overall mood?",
                            icon: "heart.fill",
                            value: $mood
                        )
                        
                        moodQuestion(
                            title: "Energy Level",
                            subtitle: "How energetic do you feel?",
                            icon: "bolt.fill",
                            value: $productivity
                        )
                    }
                    .padding(.horizontal)
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Any notes?")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.textPrimary.opacity(0.7))
                        
                        TextField("Optional thoughts...", text: $notes, axis: .vertical)
                            .lineLimit(3...6)
                            .font(.system(.body, design: .rounded))
                            .padding()
                            .background(Color.primaryPastel.opacity(0.3))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Save button
                    Button(action: saveEntry) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Check-in")
                        }
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.textPrimary)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .background(Color.backgroundPastel)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
            }
        }
    }
    
    private func moodQuestion(title: String, subtitle: String, icon: String, value: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.primaryPastel)
                Text(title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
            Text(subtitle)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.textPrimary.opacity(0.6))
            
            // Emoji selector
            HStack(spacing: 0) {
                ForEach(MoodLevel.allCases, id: \.rawValue) { level in
                    Button(action: { value.wrappedValue = level.rawValue }) {
                        VStack(spacing: 4) {
                            Text(level.emoji)
                                .font(.system(size: value.wrappedValue == level.rawValue ? 32 : 24))
                            Text(level.description)
                                .font(.system(size: 9, design: .rounded))
                                .foregroundColor(.textPrimary.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            value.wrappedValue == level.rawValue
                                ? Color.primaryPastel.opacity(0.5)
                                : Color.clear
                        )
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
    
    private func saveEntry() {
        if let existing = existingEntry {
            // Update existing
            existing.discomfort = discomfort
            existing.sleep = sleep
            existing.diet = diet
            existing.mood = mood
            existing.productivity = productivity
            existing.notes = notes.isEmpty ? nil : notes
        } else {
            // Create new
            let entry = MoodEntry(
                discomfort: discomfort,
                sleep: sleep,
                diet: diet,
                mood: mood,
                productivity: productivity,
                notes: notes.isEmpty ? nil : notes
            )
            modelContext.insert(entry)
        }
        
        dismiss()
    }
}

#Preview {
    MoodView()
        .modelContainer(for: MoodEntry.self, inMemory: true)
}


