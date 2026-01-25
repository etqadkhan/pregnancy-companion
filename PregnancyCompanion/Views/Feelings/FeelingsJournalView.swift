import SwiftUI
import SwiftData

struct FeelingsJournalView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FeelingsEntry.date, order: .reverse) private var feelingsEntries: [FeelingsEntry]
    
    @State private var showEntrySheet = false
    @State private var selectedEntry: FeelingsEntry? = nil
    
    private var todayEntry: FeelingsEntry? {
        feelingsEntries.first { $0.isToday }
    }
    
    private var pastEntries: [FeelingsEntry] {
        Array(feelingsEntries.filter { !$0.isToday })
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Today's Entry Status
                    todayStatusCard
                    
                    // Past Entries
                    if !pastEntries.isEmpty {
                        pastEntriesSection
                    }
                }
                .padding()
            }
            .background(Color.backgroundPastel)
            .navigationTitle("Feelings & Journal")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showEntrySheet) {
                FeelingsEntrySheet(existingEntry: todayEntry)
            }
            .sheet(item: $selectedEntry) { entry in
                FeelingsEntryDetailView(entry: entry)
            }
        }
    }
    
    // MARK: - Today Status Card
    private var todayStatusCard: some View {
        VStack(spacing: 16) {
            if let entry = todayEntry {
                // Already logged today
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Today's Entry")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        if let journalText = entry.journalText, !journalText.isEmpty {
                            Text(journalText)
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.textPrimary.opacity(0.7))
                                .lineLimit(2)
                        } else {
                            Text("Your feelings are recorded")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.textPrimary.opacity(0.6))
                        }
                    }
                    
                    Spacer()
                    
                    // Average feelings display
                    ZStack {
                        Circle()
                            .fill(feelingsColor(for: entry.averageScore))
                            .frame(width: 60, height: 60)
                        
                        Text(feelingsEmoji(for: entry.averageScore))
                            .font(.system(size: 28))
                    }
                }
                
                Button(action: { showEntrySheet = true }) {
                    Text("Update Entry")
                        .secondaryButtonStyle()
                }
            } else {
                // No entry today
                VStack(spacing: 16) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.primaryPastel)
                    
                    Text("How are you feeling today?")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.textPrimary)
                    
                    Text("Share your feelings and write in your journal")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.6))
                        .multilineTextAlignment(.center)
                    
                    Button(action: { showEntrySheet = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Log Feelings")
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
    
    // MARK: - Past Entries Section
    private var pastEntriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Past Entries")
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundColor(.textPrimary)
                .padding(.leading, 4)
            
            VStack(spacing: 8) {
                ForEach(pastEntries, id: \.id) { entry in
                    FeelingsHistoryRow(entry: entry) {
                        selectedEntry = entry
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func feelingsEmoji(for score: Double) -> String {
        switch score {
        case 4.5...5.0: return "😄"
        case 3.5..<4.5: return "🙂"
        case 2.5..<3.5: return "😐"
        case 1.5..<2.5: return "😔"
        default: return "😢"
        }
    }
    
    private func feelingsColor(for score: Double) -> Color {
        switch score {
        case 4.0...5.0: return Color.accentPastel
        case 3.0..<4.0: return Color.primaryPastel
        case 2.0..<3.0: return Color.softPeach
        default: return Color.secondaryPastel
        }
    }
}

// MARK: - Feelings History Row
struct FeelingsHistoryRow: View {
    let entry: FeelingsEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text(feelingsEmoji(for: entry.averageScore))
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.dateString)
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundColor(.textPrimary)
                    
                    if let journalText = entry.journalText, !journalText.isEmpty {
                        Text(journalText)
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.textPrimary.opacity(0.6))
                            .lineLimit(1)
                    } else {
                        Text("Feelings logged")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.textPrimary.opacity(0.5))
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textPrimary.opacity(0.3))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func feelingsEmoji(for score: Double) -> String {
        switch score {
        case 4.5...5.0: return "😄"
        case 3.5..<4.5: return "🙂"
        case 2.5..<3.5: return "😐"
        case 1.5..<2.5: return "😔"
        default: return "😢"
        }
    }
}

// MARK: - Feelings Entry Sheet
struct FeelingsEntrySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let existingEntry: FeelingsEntry?
    
    @State private var howFeeling: Int = 3
    @State private var feelBump: Int = 3
    @State private var connectedToBaby: Int = 3
    @State private var feelSupported: Int = 3
    @State private var excitedAboutJourney: Int = 3
    @State private var journalText: String = ""
    
    init(existingEntry: FeelingsEntry?) {
        self.existingEntry = existingEntry
        if let entry = existingEntry {
            _howFeeling = State(initialValue: entry.howFeeling)
            _feelBump = State(initialValue: entry.feelBump)
            _connectedToBaby = State(initialValue: entry.connectedToBaby)
            _feelSupported = State(initialValue: entry.feelSupported)
            _excitedAboutJourney = State(initialValue: entry.excitedAboutJourney)
            _journalText = State(initialValue: entry.journalText ?? "")
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
                    
                    // Feelings questions
                    VStack(spacing: 20) {
                        feelingsQuestion(
                            question: .howFeeling,
                            value: $howFeeling
                        )
                        
                        feelingsQuestion(
                            question: .feelBump,
                            value: $feelBump
                        )
                        
                        feelingsQuestion(
                            question: .connectedToBaby,
                            value: $connectedToBaby
                        )
                        
                        feelingsQuestion(
                            question: .feelSupported,
                            value: $feelSupported
                        )
                        
                        feelingsQuestion(
                            question: .excitedAboutJourney,
                            value: $excitedAboutJourney
                        )
                    }
                    .padding(.horizontal)
                    
                    // Journal entry
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "book.fill")
                                .foregroundColor(.primaryPastel)
                            Text("Journal Entry")
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                .foregroundColor(.textPrimary)
                        }
                        
                        Text("Write about your day, thoughts, or anything you'd like to remember")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.textPrimary.opacity(0.6))
                        
                        TextEditor(text: $journalText)
                            .font(.system(.body, design: .rounded))
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(Color.primaryPastel.opacity(0.2))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primaryPastel.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Save button
                    Button(action: saveEntry) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Entry")
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
    
    private func feelingsQuestion(question: FeelingsQuestion, value: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: question.icon)
                    .foregroundColor(.primaryPastel)
                Text(question.rawValue)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
            }
            
            Text(question.subtitle)
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
            existing.howFeeling = howFeeling
            existing.feelBump = feelBump
            existing.connectedToBaby = connectedToBaby
            existing.feelSupported = feelSupported
            existing.excitedAboutJourney = excitedAboutJourney
            existing.journalText = journalText.isEmpty ? nil : journalText
        } else {
            // Create new
            let entry = FeelingsEntry(
                howFeeling: howFeeling,
                feelBump: feelBump,
                connectedToBaby: connectedToBaby,
                feelSupported: feelSupported,
                excitedAboutJourney: excitedAboutJourney,
                journalText: journalText.isEmpty ? nil : journalText
            )
            modelContext.insert(entry)
        }
        
        dismiss()
    }
}

// MARK: - Feelings Entry Detail View
struct FeelingsEntryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let entry: FeelingsEntry
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Date header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.dateString)
                            .font(.system(.title2, design: .rounded, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Feelings & Journal Entry")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.textPrimary.opacity(0.6))
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Feelings summary
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Feelings")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            feelingDetailRow(
                                question: .howFeeling,
                                value: entry.howFeeling
                            )
                            
                            feelingDetailRow(
                                question: .feelBump,
                                value: entry.feelBump
                            )
                            
                            feelingDetailRow(
                                question: .connectedToBaby,
                                value: entry.connectedToBaby
                            )
                            
                            feelingDetailRow(
                                question: .feelSupported,
                                value: entry.feelSupported
                            )
                            
                            feelingDetailRow(
                                question: .excitedAboutJourney,
                                value: entry.excitedAboutJourney
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Journal entry
                    if let journalText = entry.journalText, !journalText.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundColor(.primaryPastel)
                                Text("Journal Entry")
                                    .font(.system(.headline, design: .rounded, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }
                            .padding(.horizontal)
                            
                            Text(journalText)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.textPrimary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.primaryPastel.opacity(0.2))
                                .cornerRadius(12)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color.backgroundPastel)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
            }
        }
    }
    
    private func feelingDetailRow(question: FeelingsQuestion, value: Int) -> some View {
        HStack {
            Image(systemName: question.icon)
                .foregroundColor(.primaryPastel)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(question.rawValue)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Text(question.subtitle)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.6))
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Text(MoodLevel(rawValue: value)?.emoji ?? "😐")
                    .font(.title3)
                Text(MoodLevel(rawValue: value)?.description ?? "Okay")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.6))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    FeelingsJournalView()
        .modelContainer(for: FeelingsEntry.self, inMemory: true)
}
