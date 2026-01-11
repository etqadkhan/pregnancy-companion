import SwiftUI
import SwiftData

struct DoctorVisitSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let visit: DoctorVisit?
    let selectedDate: Date
    
    @State private var date: Date
    @State private var weight: String = ""
    @State private var notes: String = ""
    @State private var injections: String = ""
    @State private var bloodPressure: String = ""
    
    @State private var showDeleteConfirmation = false
    
    init(visit: DoctorVisit?, selectedDate: Date) {
        self.visit = visit
        self.selectedDate = selectedDate
        
        if let visit = visit {
            _date = State(initialValue: visit.date)
            _weight = State(initialValue: visit.weight != nil ? String(format: "%.1f", visit.weight!) : "")
            _notes = State(initialValue: visit.notes)
            _injections = State(initialValue: visit.injections ?? "")
            _bloodPressure = State(initialValue: visit.bloodPressure ?? "")
        } else {
            _date = State(initialValue: selectedDate)
        }
    }
    
    var isEditing: Bool {
        visit != nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    ZStack {
                        Circle()
                            .fill(Color.softBlue.opacity(0.3))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "stethoscope")
                            .font(.system(size: 36))
                            .foregroundColor(.textPrimary.opacity(0.7))
                    }
                    .padding(.top, 20)
                    
                    Text(isEditing ? "Edit Visit" : "New Appointment")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    // Form
                    VStack(spacing: 16) {
                        // Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.system(.subheadline, design: .rounded, weight: .medium))
                                .foregroundColor(.textPrimary.opacity(0.7))
                            
                            DatePicker(
                                "Date",
                                selection: $date,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .labelsHidden()
                            .tint(.textPrimary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Weight
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Weight at Visit")
                                .font(.system(.subheadline, design: .rounded, weight: .medium))
                                .foregroundColor(.textPrimary.opacity(0.7))
                            
                            HStack {
                                TextField("e.g., 65.5", text: $weight)
                                    .keyboardType(.decimalPad)
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.textPrimary)
                                Text("kg")
                                    .foregroundColor(.textPrimary.opacity(0.5))
                            }
                            .padding()
                            .background(Color.primaryPastel.opacity(0.3))
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Blood Pressure (optional)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Blood Pressure (optional)")
                                .font(.system(.subheadline, design: .rounded, weight: .medium))
                                .foregroundColor(.textPrimary.opacity(0.7))
                            
                            TextField("e.g., 120/80", text: $bloodPressure)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.textPrimary)
                                .padding()
                                .background(Color.primaryPastel.opacity(0.3))
                                .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Notes
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Doctor's Notes")
                                .font(.system(.subheadline, design: .rounded, weight: .medium))
                                .foregroundColor(.textPrimary.opacity(0.7))
                            
                            TextField("What did the doctor say?", text: $notes, axis: .vertical)
                                .lineLimit(4...8)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.textPrimary)
                                .padding()
                                .background(Color.primaryPastel.opacity(0.3))
                                .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Injections
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Injections/Medications (optional)")
                                .font(.system(.subheadline, design: .rounded, weight: .medium))
                                .foregroundColor(.textPrimary.opacity(0.7))
                            
                            TextField("Any injections given?", text: $injections, axis: .vertical)
                                .lineLimit(2...4)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.textPrimary)
                                .padding()
                                .background(Color.primaryPastel.opacity(0.3))
                                .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Save button
                    Button(action: saveVisit) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text(isEditing ? "Update Visit" : "Save Appointment")
                        }
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.textPrimary)
                        .cornerRadius(14)
                    }
                    .padding(.horizontal)
                    
                    // Delete button (if editing)
                    if isEditing {
                        Button(action: { showDeleteConfirmation = true }) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Visit")
                            }
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .foregroundColor(.red.opacity(0.8))
                        }
                        .padding(.bottom, 20)
                    }
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
            .confirmationDialog("Delete Visit", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    deleteVisit()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete this visit record?")
            }
        }
    }
    
    private func saveVisit() {
        let weightValue = Double(weight)
        
        if let existingVisit = visit {
            // Update existing
            existingVisit.date = date
            existingVisit.weight = weightValue
            existingVisit.notes = notes
            existingVisit.injections = injections.isEmpty ? nil : injections
            existingVisit.bloodPressure = bloodPressure.isEmpty ? nil : bloodPressure
            
            // Update notifications
            NotificationManager.shared.cancelDoctorVisitReminder(for: existingVisit)
            if existingVisit.isUpcoming {
                NotificationManager.shared.scheduleDoctorVisitReminder(for: existingVisit)
            }
        } else {
            // Create new
            let newVisit = DoctorVisit(
                date: date,
                weight: weightValue,
                notes: notes,
                injections: injections.isEmpty ? nil : injections,
                bloodPressure: bloodPressure.isEmpty ? nil : bloodPressure
            )
            modelContext.insert(newVisit)
            
            // Schedule notification if upcoming
            if newVisit.isUpcoming {
                NotificationManager.shared.scheduleDoctorVisitReminder(for: newVisit)
            }
        }
        
        dismiss()
    }
    
    private func deleteVisit() {
        if let visit = visit {
            NotificationManager.shared.cancelDoctorVisitReminder(for: visit)
            modelContext.delete(visit)
        }
        dismiss()
    }
}

#Preview {
    DoctorVisitSheet(visit: nil, selectedDate: Date())
        .modelContainer(for: DoctorVisit.self, inMemory: true)
}


