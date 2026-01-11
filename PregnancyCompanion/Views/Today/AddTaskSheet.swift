import SwiftUI
import SwiftData

struct AddTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var title: String = ""
    @State private var reminderTime: Date = Date()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header illustration
                ZStack {
                    Circle()
                        .fill(Color.primaryPastel.opacity(0.5))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.textPrimary.opacity(0.7))
                }
                .padding(.top, 20)
                
                Text("New Reminder")
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                // Form
                VStack(spacing: 16) {
                    // Task title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What do you need to remember?")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.textPrimary.opacity(0.7))
                        
                        TextField("e.g., Take vitamins", text: $title)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.textPrimary)
                            .padding()
                            .background(Color.primaryPastel.opacity(0.3))
                            .cornerRadius(12)
                    }
                    
                    // Time picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Remind me at")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.textPrimary.opacity(0.7))
                        
                        DatePicker(
                            "Time",
                            selection: $reminderTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .frame(maxHeight: 120)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Save button
                Button(action: saveTask) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Add Reminder")
                    }
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        title.isEmpty
                            ? Color.textPrimary.opacity(0.3)
                            : Color.textPrimary
                    )
                    .cornerRadius(14)
                }
                .disabled(title.isEmpty)
                .padding(.horizontal)
                .padding(.bottom, 20)
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
    
    private func saveTask() {
        guard !title.isEmpty else { return }
        
        let task = TodoTask(title: title, reminderTime: reminderTime)
        modelContext.insert(task)
        
        // Schedule notifications
        NotificationManager.shared.scheduleNotifications(for: task)
        
        dismiss()
    }
}

#Preview {
    AddTaskSheet()
        .modelContainer(for: TodoTask.self, inMemory: true)
}


