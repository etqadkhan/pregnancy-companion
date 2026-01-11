import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var dueDate: Date = Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date()
    @State private var useWeeksInstead: Bool = false
    @State private var weeksOfGestation: String = ""
    
    @State private var currentStep: Int = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.primaryPastel, Color.secondaryPastel.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<4) { step in
                        Capsule()
                            .fill(step <= currentStep ? Color.textPrimary : Color.textPrimary.opacity(0.2))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                Spacer()
                
                // Content based on step
                TabView(selection: $currentStep) {
                    welcomeStep.tag(0)
                    nameStep.tag(1)
                    detailsStep.tag(2)
                    dueDateStep.tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                Spacer()
                
                // Navigation buttons
                HStack {
                    if currentStep > 0 {
                        Button(action: { withAnimation { currentStep -= 1 } }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .secondaryButtonStyle()
                        }
                    }
                    
                    Spacer()
                    
                    if currentStep < 3 {
                        Button(action: { withAnimation { currentStep += 1 } }) {
                            HStack {
                                Text("Next")
                                Image(systemName: "chevron.right")
                            }
                            .primaryButtonStyle()
                        }
                        .disabled(!canProceed)
                        .opacity(canProceed ? 1 : 0.5)
                    } else {
                        Button(action: saveProfile) {
                            HStack {
                                Text("Get Started")
                                Image(systemName: "heart.fill")
                            }
                            .primaryButtonStyle()
                        }
                        .disabled(!canComplete)
                        .opacity(canComplete ? 1 : 0.5)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
    }
    
    // MARK: - Steps
    
    private var welcomeStep: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.secondaryPastel, Color.primaryPastel],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Welcome to\nBaby Bump")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.textPrimary)
            
            Text("Your gentle daily reminder to take care of yourself and your little one")
                .font(.system(.body, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.textPrimary.opacity(0.8))
                .padding(.horizontal, 40)
        }
        .padding()
    }
    
    private var nameStep: some View {
        VStack(spacing: 24) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentPastel)
            
            Text("What's your name?")
                .font(.system(.title, design: .rounded, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            TextField("Enter your name", text: $name)
                .font(.system(.title3, design: .rounded))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 40)
        }
        .padding()
    }
    
    private var detailsStep: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 60))
                .foregroundColor(.softPeach)
            
            Text("A few more details")
                .font(.system(.title, design: .rounded, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 16) {
                HStack {
                    Text("Age")
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(.textPrimary)
                    Spacer()
                    TextField("Years", text: $age)
                        .keyboardType(.numberPad)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                HStack {
                    Text("Current Weight")
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(.textPrimary)
                    Spacer()
                    TextField("kg", text: $weight)
                        .keyboardType(.decimalPad)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                    Text("kg")
                        .foregroundColor(.textPrimary.opacity(0.6))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
            }
            .padding(.horizontal, 40)
        }
        .padding()
    }
    
    private var dueDateStep: some View {
        VStack(spacing: 24) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 60))
                .foregroundColor(.softBlue)
            
            Text("When is your due date?")
                .font(.system(.title, design: .rounded, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            // Toggle between due date and weeks
            Picker("Input Method", selection: $useWeeksInstead) {
                Text("Due Date").tag(false)
                Text("Weeks of Gestation").tag(true)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 40)
            
            if useWeeksInstead {
                HStack {
                    Text("Current Week")
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundColor(.textPrimary)
                    Spacer()
                    TextField("Weeks", text: $weeksOfGestation)
                        .keyboardType(.numberPad)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 80)
                    Text("weeks")
                        .foregroundColor(.textPrimary.opacity(0.6))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 40)
            } else {
                DatePicker(
                    "Due Date",
                    selection: $dueDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(Color(red: 147/255, green: 112/255, blue: 219/255))
                .environment(\.colorScheme, .light)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 20)
            }
        }
        .padding()
    }
    
    // MARK: - Helpers
    
    private var canProceed: Bool {
        switch currentStep {
        case 0: return true
        case 1: return name.isNotEmpty()
        case 2: return !age.isEmpty && !weight.isEmpty
        default: return true
        }
    }
    
    private var canComplete: Bool {
        guard name.isNotEmpty(),
              let _ = Int(age),
              let _ = Double(weight) else {
            return false
        }
        
        if useWeeksInstead {
            guard let weeks = Int(weeksOfGestation), weeks >= 1, weeks <= 42 else {
                return false
            }
        }
        
        return true
    }
    
    private var calculatedDueDate: Date {
        if useWeeksInstead, let weeks = Int(weeksOfGestation) {
            // Calculate due date from current weeks
            // Due date = today + (40 - current weeks) weeks
            let remainingWeeks = 40 - weeks
            return Calendar.current.date(byAdding: .weekOfYear, value: remainingWeeks, to: Date()) ?? Date()
        }
        return dueDate
    }
    
    private func saveProfile() {
        guard let ageInt = Int(age),
              let weightDouble = Double(weight) else {
            return
        }
        
        let profile = UserProfile(
            name: name,
            age: ageInt,
            weight: weightDouble,
            dueDate: calculatedDueDate
        )
        
        modelContext.insert(profile)
        
        // Add default tasks
        addDefaultTasks()
    }
    
    private func addDefaultTasks() {
        let calendar = Calendar.current
        let today = Date()
        
        let defaultTasks: [(String, Int, Int)] = [
            ("Take morning medicine", 8, 0),
            ("Eat breakfast", 9, 0),
            ("Take afternoon medicine", 14, 0),
            ("Eat lunch", 13, 0),
            ("Apply oil on tummy", 20, 0),
            ("Read Quran/Dua", 21, 0),
            ("Take evening medicine", 20, 0),
            ("Eat dinner", 19, 0)
        ]
        
        for (title, hour, minute) in defaultTasks {
            if let reminderTime = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: today) {
                let task = TodoTask(title: title, reminderTime: reminderTime)
                modelContext.insert(task)
            }
        }
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: UserProfile.self, inMemory: true)
}


