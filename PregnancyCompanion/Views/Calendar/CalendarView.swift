import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DoctorVisit.date) private var visits: [DoctorVisit]
    
    @State private var selectedDate = Date()
    @State private var showAddVisit = false
    @State private var selectedVisit: DoctorVisit?
    
    private var upcomingVisits: [DoctorVisit] {
        visits.filter { $0.isUpcoming || $0.isToday }
    }
    
    private var pastVisits: [DoctorVisit] {
        visits.filter { !$0.isUpcoming && !$0.isToday }
            .sorted { $0.date > $1.date }
    }
    
    private var visitDates: Set<Date> {
        Set(visits.map { Calendar.current.startOfDay(for: $0.date) })
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Calendar
                    calendarSection
                    
                    // Upcoming Visits
                    if !upcomingVisits.isEmpty {
                        visitsSection(title: "Upcoming Appointments", visits: upcomingVisits)
                    }
                    
                    // Past Visits
                    if !pastVisits.isEmpty {
                        visitsSection(title: "Past Visits", visits: pastVisits)
                    }
                    
                    // Empty state
                    if visits.isEmpty {
                        emptyStateView
                    }
                }
                .padding()
            }
            .background(Color.backgroundPastel)
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddVisit = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showAddVisit) {
                DoctorVisitSheet(visit: nil, selectedDate: selectedDate)
            }
            .sheet(item: $selectedVisit) { visit in
                DoctorVisitSheet(visit: visit, selectedDate: visit.date)
            }
        }
    }
    
    // MARK: - Calendar Section
    private var calendarSection: some View {
        VStack(spacing: 16) {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(Color(red: 147/255, green: 112/255, blue: 219/255)) // Purple tint for better visibility
            .environment(\.colorScheme, .light) // Ensure light mode for calendar
            
            // Show visits for selected date
            let visitsOnDate = visits.filter {
                Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
            }
            
            if !visitsOnDate.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Appointments on \(selectedDate.formattedDate())")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundColor(.textPrimary.opacity(0.7))
                    
                    ForEach(visitsOnDate, id: \.id) { visit in
                        VisitRow(visit: visit)
                            .onTapGesture {
                                selectedVisit = visit
                            }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Visits Section
    private func visitsSection(title: String, visits: [DoctorVisit]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundColor(.textPrimary)
                .padding(.leading, 4)
            
            VStack(spacing: 8) {
                ForEach(visits, id: \.id) { visit in
                    VisitRow(visit: visit)
                        .onTapGesture {
                            selectedVisit = visit
                        }
                }
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 48))
                .foregroundColor(.softBlue)
            
            Text("No appointments scheduled")
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.textPrimary)
            
            Text("Keep track of your doctor visits and checkups")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.textPrimary.opacity(0.6))
                .multilineTextAlignment(.center)
            
            Button(action: { showAddVisit = true }) {
                Text("Add Appointment")
                    .primaryButtonStyle()
            }
        }
        .padding(40)
    }
}

// MARK: - Visit Row
struct VisitRow: View {
    let visit: DoctorVisit
    
    var body: some View {
        HStack(spacing: 16) {
            // Date indicator
            VStack(spacing: 2) {
                Text(dayNumber)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text(monthAbbrev)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.6))
            }
            .frame(width: 44)
            .padding(.vertical, 8)
            .background(visit.isUpcoming ? Color.softBlue.opacity(0.3) : Color.primaryPastel.opacity(0.3))
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Doctor's Visit")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                if let weight = visit.weight {
                    HStack(spacing: 4) {
                        Image(systemName: "scalemass")
                            .font(.caption2)
                        Text("\(String(format: "%.1f", weight)) kg")
                            .font(.system(.caption, design: .rounded))
                    }
                    .foregroundColor(.textPrimary.opacity(0.6))
                }
                
                if !visit.notes.isEmpty {
                    Text(visit.notes)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.5))
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.textPrimary.opacity(0.3))
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: visit.date)
    }
    
    private var monthAbbrev: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: visit.date)
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: DoctorVisit.self, inMemory: true)
}


