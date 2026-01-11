import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoTask.reminderTime) private var tasks: [TodoTask]
    @Query private var profiles: [UserProfile]
    
    @State private var showAddTask = false
    
    private var profile: UserProfile? {
        profiles.first
    }
    
    private var incompleteTasks: [TodoTask] {
        tasks.filter { !$0.isCompletedToday && $0.isActive }
    }
    
    private var completedTasks: [TodoTask] {
        tasks.filter { $0.isCompletedToday && $0.isActive }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Greeting Card
                    greetingCard
                    
                    // Tasks Section
                    if !incompleteTasks.isEmpty {
                        tasksSection(title: "To Do", tasks: incompleteTasks, isCompleted: false)
                    }
                    
                    if !completedTasks.isEmpty {
                        tasksSection(title: "Completed", tasks: completedTasks, isCompleted: true)
                    }
                    
                    if tasks.isEmpty {
                        emptyStateView
                    }
                }
                .padding()
            }
            .background(Color.backgroundPastel)
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddTask = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskSheet()
            }
            .onAppear {
                resetTasksForNewDay()
            }
        }
    }
    
    // MARK: - Greeting Card
    private var greetingCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.7))
                    
                    Text(profile?.name ?? "Mama")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Week \(profile?.currentWeek ?? 20)")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    Text(Date().formattedDate())
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.6))
                }
            }
            
            // Progress summary
            HStack(spacing: 16) {
                progressPill(
                    count: incompleteTasks.count,
                    label: "remaining",
                    color: .secondaryPastel
                )
                
                progressPill(
                    count: completedTasks.count,
                    label: "done",
                    color: .accentPastel
                )
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.primaryPastel.opacity(0.6), Color.secondaryPastel.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
    
    private func progressPill(count: Int, label: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Text("\(count)")
                .font(.system(.headline, design: .rounded, weight: .bold))
            Text(label)
                .font(.system(.caption, design: .rounded))
        }
        .foregroundColor(.textPrimary)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.5))
        .cornerRadius(20)
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning,"
        case 12..<17: return "Good Afternoon,"
        default: return "Good Evening,"
        }
    }
    
    // MARK: - Tasks Section
    private func tasksSection(title: String, tasks: [TodoTask], isCompleted: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundColor(.textPrimary)
                .padding(.leading, 4)
            
            VStack(spacing: 8) {
                ForEach(tasks, id: \.id) { task in
                    TaskRow(task: task, isCompleted: isCompleted)
                }
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .foregroundColor(.accentPastel)
            
            Text("No tasks yet")
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.textPrimary)
            
            Text("Tap + to add your first reminder")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.textPrimary.opacity(0.6))
            
            Button(action: { showAddTask = true }) {
                Text("Add Task")
                    .primaryButtonStyle()
            }
        }
        .padding(40)
    }
    
    // MARK: - Helpers
    private func resetTasksForNewDay() {
        for task in tasks {
            task.resetForNewDay()
        }
    }
}

// MARK: - Task Row
struct TaskRow: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var task: TodoTask
    let isCompleted: Bool
    
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Checkbox
            Button(action: toggleCompletion) {
                ZStack {
                    Circle()
                        .stroke(isCompleted ? Color.accentPastel : Color.textPrimary.opacity(0.3), lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if isCompleted {
                        Circle()
                            .fill(Color.accentPastel)
                            .frame(width: 28, height: 28)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundColor(isCompleted ? .textPrimary.opacity(0.5) : .textPrimary)
                    .strikethrough(isCompleted)
                
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    Text(task.reminderTimeString)
                        .font(.system(.caption, design: .rounded))
                }
                .foregroundColor(.textPrimary.opacity(0.5))
            }
            
            Spacer()
            
            // Delete button
            Button(action: { showDeleteConfirmation = true }) {
                Image(systemName: "trash")
                    .font(.caption)
                    .foregroundColor(.textPrimary.opacity(0.4))
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        .confirmationDialog("Delete Task", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                deleteTask()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete '\(task.title)'?")
        }
    }
    
    private func toggleCompletion() {
        let wasCompleted = task.isCompletedToday
        
        withAnimation(.spring(response: 0.3)) {
            if wasCompleted {
                task.isCompleted = false
                task.lastCompletedDate = nil
                // Play undo sound
                SoundManager.shared.playUndoSound()
            } else {
                task.markCompleted()
                // Play completion sound
                SoundManager.shared.playCompletionSound()
            }
        }
        
        // Update notifications
        NotificationManager.shared.updateNotifications(for: task)
    }
    
    private func deleteTask() {
        SoundManager.shared.playDeleteSound()
        NotificationManager.shared.cancelNotifications(for: task)
        modelContext.delete(task)
    }
}

#Preview {
    TodayView()
        .modelContainer(for: [UserProfile.self, TodoTask.self], inMemory: true)
}


