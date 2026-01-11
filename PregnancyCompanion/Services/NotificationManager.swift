import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: - Request Permission
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Schedule Today's Notifications for Task
    /// Schedules notifications for today only - call this on app launch and after midnight
    func scheduleTodaysNotifications(for task: TodoTask) {
        guard task.isActive && !task.isCompletedToday else { return }
        
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let now = Date()
        
        // Get hour and minute from reminder time
        let hour = calendar.component(.hour, from: task.reminderTime)
        let minute = calendar.component(.minute, from: task.reminderTime)
        
        // Get today's reminder time
        guard let todayReminder = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) else { return }
        
        // Only schedule if the reminder time hasn't passed yet
        if todayReminder > now {
            scheduleMainReminder(for: task, at: todayReminder)
        }
        
        // Schedule nudges for hours after the reminder time (if task not completed)
        scheduleNudgesForToday(for: task, startHour: hour, startMinute: minute)
    }
    
    // MARK: - Schedule Main Reminder (One-Time for Today)
    private func scheduleMainReminder(for task: TodoTask, at date: Date) {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder 💕"
        content.body = task.title
        content.sound = .default
        content.categoryIdentifier = "TASK_REMINDER"
        content.userInfo = ["taskId": task.id.uuidString]
        content.badge = 1
        
        // Use exact date components for today (one-time, not repeating)
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "task-\(task.id.uuidString)-main-\(dateString(from: date))",
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Scheduled reminder for \(task.title) at \(date)")
            }
        }
    }
    
    // MARK: - Schedule Nudges for Today
    private func scheduleNudgesForToday(for task: TodoTask, startHour: Int, startMinute: Int) {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let now = Date()
        let today = calendar.startOfDay(for: now)
        
        // Schedule nudges for hours after the reminder time (for today only)
        for hourOffset in 1...12 {
            let nudgeHour = (startHour + hourOffset) % 24
            
            // Don't send nudges during late night (11pm - 7am)
            if nudgeHour >= 23 || nudgeHour < 7 {
                continue
            }
            
            // Skip if this nudge hour has already passed today
            guard let nudgeTime = calendar.date(bySettingHour: nudgeHour, minute: startMinute, second: 0, of: today),
                  nudgeTime > now else {
                continue
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Gentle Reminder 🌸"
            content.body = "Don't forget: \(task.title)"
            content.sound = .default
            content.categoryIdentifier = "TASK_NUDGE"
            content.userInfo = ["taskId": task.id.uuidString, "isNudge": true]
            
            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: nudgeTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "task-\(task.id.uuidString)-nudge-\(hourOffset)-\(dateString(from: today))",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling nudge: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Legacy method for compatibility (schedules daily repeating + today's)
    func scheduleNotifications(for task: TodoTask) {
        guard task.isActive else { return }
        
        // Cancel any existing notifications for this task
        cancelNotifications(for: task)
        
        // Schedule today's notifications
        scheduleTodaysNotifications(for: task)
        
        // Also schedule a daily repeating reminder as backup
        scheduleDailyRepeatingReminder(for: task)
    }
    
    // MARK: - Daily Repeating Reminder (Backup)
    private func scheduleDailyRepeatingReminder(for task: TodoTask) {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: task.reminderTime)
        let minute = calendar.component(.minute, from: task.reminderTime)
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder 💕"
        content.body = task.title
        content.sound = .default
        content.categoryIdentifier = "TASK_REMINDER"
        content.userInfo = ["taskId": task.id.uuidString]
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "task-\(task.id.uuidString)-daily",
            content: content,
            trigger: trigger
        )
        
        center.add(request)
    }
    
    // MARK: - Cancel Notifications for Task
    func cancelNotifications(for task: TodoTask) {
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests { requests in
            let identifiersToRemove = requests
                .filter { $0.identifier.contains("task-\(task.id.uuidString)") }
                .map { $0.identifier }
            
            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
            center.removeDeliveredNotifications(withIdentifiers: identifiersToRemove)
        }
    }
    
    // MARK: - Cancel Today's Notifications for Task (when completed)
    func cancelTodaysNotifications(for task: TodoTask) {
        let center = UNUserNotificationCenter.current()
        let todayStr = dateString(from: Date())
        
        center.getPendingNotificationRequests { requests in
            let identifiersToRemove = requests
                .filter { 
                    $0.identifier.contains("task-\(task.id.uuidString)") && 
                    $0.identifier.contains(todayStr)
                }
                .map { $0.identifier }
            
            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
        }
        
        // Also remove any delivered notifications
        center.getDeliveredNotifications { notifications in
            let identifiersToRemove = notifications
                .filter { $0.request.identifier.contains("task-\(task.id.uuidString)") }
                .map { $0.request.identifier }
            
            center.removeDeliveredNotifications(withIdentifiers: identifiersToRemove)
        }
        
        // Update badge
        updateBadgeCount()
    }
    
    // MARK: - Update Notifications (when task is completed/uncompleted)
    func updateNotifications(for task: TodoTask) {
        if task.isCompletedToday {
            // Cancel today's remaining notifications
            cancelTodaysNotifications(for: task)
        } else {
            // Re-enable today's notifications
            scheduleTodaysNotifications(for: task)
        }
    }
    
    // MARK: - Cancel All Notifications
    func cancelAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        center.setBadgeCount(0)
    }
    
    // MARK: - Reschedule All Tasks for Today
    /// Call this on app launch and schedule for midnight daily
    func rescheduleAllTasksForToday(tasks: [TodoTask]) {
        for task in tasks where task.isActive && !task.isCompletedToday {
            scheduleTodaysNotifications(for: task)
        }
        updateBadgeCount()
    }
    
    // MARK: - Update Badge Count
    private func updateBadgeCount() {
        // This would need access to the model context to count incomplete tasks
        // For now, just clear the badge when tasks are completed
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
    
    // MARK: - Helper
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // MARK: - Schedule Doctor Appointment Reminder
    func scheduleDoctorVisitReminder(for visit: DoctorVisit) {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        
        // Remind day before at 9 AM
        guard let dayBefore = calendar.date(byAdding: .day, value: -1, to: visit.date) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Doctor's Visit Tomorrow 🏥"
        content.body = "You have a doctor's appointment tomorrow. Don't forget to prepare any questions!"
        content.sound = .default
        
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: dayBefore)
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "doctor-visit-\(visit.id.uuidString)",
            content: content,
            trigger: trigger
        )
        
        center.add(request)
        
        // Also remind on the day at 7 AM
        let dayOfContent = UNMutableNotificationContent()
        dayOfContent.title = "Doctor's Visit Today 🏥"
        dayOfContent.body = "Your appointment is today. Take care!"
        dayOfContent.sound = .default
        
        var dayOfComponents = calendar.dateComponents([.year, .month, .day], from: visit.date)
        dayOfComponents.hour = 7
        dayOfComponents.minute = 0
        
        let dayOfTrigger = UNCalendarNotificationTrigger(dateMatching: dayOfComponents, repeats: false)
        
        let dayOfRequest = UNNotificationRequest(
            identifier: "doctor-visit-day-\(visit.id.uuidString)",
            content: dayOfContent,
            trigger: dayOfTrigger
        )
        
        center.add(dayOfRequest)
    }
    
    // MARK: - Cancel Doctor Visit Reminder
    func cancelDoctorVisitReminder(for visit: DoctorVisit) {
        let center = UNUserNotificationCenter.current()
        let identifiers = [
            "doctor-visit-\(visit.id.uuidString)",
            "doctor-visit-day-\(visit.id.uuidString)"
        ]
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, 
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let taskIdString = userInfo["taskId"] as? String {
            // Post notification for the app to handle
            NotificationCenter.default.post(
                name: .taskNotificationReceived,
                object: nil,
                userInfo: ["taskId": taskIdString, "action": response.actionIdentifier]
            )
        }
        
        completionHandler()
    }
}

// MARK: - Notification Categories Setup
extension NotificationManager {
    func setupNotificationCategories() {
        let center = UNUserNotificationCenter.current()
        
        // Task reminder category with "Done" action
        let doneAction = UNNotificationAction(
            identifier: "MARK_DONE",
            title: "Done ✓",
            options: .foreground
        )
        
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE",
            title: "Remind in 30 min",
            options: []
        )
        
        let taskCategory = UNNotificationCategory(
            identifier: "TASK_REMINDER",
            actions: [doneAction, snoozeAction],
            intentIdentifiers: [],
            options: []
        )
        
        let nudgeCategory = UNNotificationCategory(
            identifier: "TASK_NUDGE",
            actions: [doneAction],
            intentIdentifiers: [],
            options: []
        )
        
        center.setNotificationCategories([taskCategory, nudgeCategory])
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let taskNotificationReceived = Notification.Name("taskNotificationReceived")
}
