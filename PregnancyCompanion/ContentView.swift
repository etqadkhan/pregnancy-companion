import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [UserProfile]
    @State private var showOnboarding = false
    
    var body: some View {
        Group {
            if profiles.isEmpty {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "checkmark.circle.fill")
                }
                .tag(0)
            
            FoodLogView()
                .tabItem {
                    Label("Food", systemImage: "leaf.fill")
                }
                .tag(1)
            
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(2)
            
            BabyTrackerView()
                .tabItem {
                    Label("Baby", systemImage: "heart.fill")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        }
        .tint(Color.textPrimary)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [UserProfile.self, TodoTask.self, FoodEntry.self, DoctorVisit.self, MoodEntry.self, WeightEntry.self], inMemory: true)
}
