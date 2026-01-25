import SwiftUI
import SwiftData

@main
struct PregnancyCompanionApp: App {
    @StateObject private var notificationManager = NotificationManager.shared
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            TodoTask.self,
            FoodEntry.self,
            DoctorVisit.self,
            MoodEntry.self,
            WeightEntry.self,
            FeelingsEntry.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        // Request notification permissions on app launch
        NotificationManager.shared.requestPermission()
        NotificationManager.shared.setupNotificationCategories()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Re-schedule notifications for existing tasks on app launch
                    rescheduleAllNotifications()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    // Also reschedule when app comes to foreground
                    rescheduleAllNotifications()
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func rescheduleAllNotifications() {
        // This ensures notifications are properly set up after app restart
        let context = sharedModelContainer.mainContext
        let descriptor = FetchDescriptor<TodoTask>()
        
        if let tasks = try? context.fetch(descriptor) {
            // Reset tasks for new day first
            for task in tasks {
                task.resetForNewDay()
            }
            
            // Schedule today's notifications for all active, incomplete tasks
            NotificationManager.shared.rescheduleAllTasksForToday(tasks: tasks)
        }
    }
}
