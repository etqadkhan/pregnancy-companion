import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query(sort: \WeightEntry.timestamp, order: .reverse) private var weightEntries: [WeightEntry]
    
    @State private var showAddWeight = false
    @State private var showEditProfile = false
    
    private var profile: UserProfile? {
        profiles.first
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Card
                    profileCard
                    
                    // Pregnancy Progress
                    pregnancyProgressCard
                    
                    // Weight Section
                    weightSection
                }
                .padding()
            }
            .background(Color.backgroundPastel)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showEditProfile = true }) {
                        Image(systemName: "pencil.circle")
                            .font(.title3)
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showAddWeight) {
                AddWeightSheet()
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileSheet()
            }
        }
    }
    
    // MARK: - Profile Card
    private var profileCard: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.primaryPastel, Color.secondaryPastel],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Text(profile?.name.prefix(1).uppercased() ?? "M")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
            }
            
            VStack(spacing: 4) {
                Text(profile?.name ?? "Mama")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Age: \(profile?.age ?? 0)")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.6))
            }
            
            // Due date info
            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("\(profile?.daysRemaining ?? 0)")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.textPrimary)
                    Text("days to go")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.6))
                }
                
                Divider()
                    .frame(height: 40)
                
                VStack(spacing: 4) {
                    Text("Week \(profile?.currentWeek ?? 0)")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundColor(.textPrimary)
                    Text("of pregnancy")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.6))
                }
                
                Divider()
                    .frame(height: 40)
                
                VStack(spacing: 4) {
                    Text(profile?.dueDate.formattedDate() ?? "-")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    Text("due date")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.6))
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Pregnancy Progress Card
    private var pregnancyProgressCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pregnancy Progress")
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Capsule()
                        .fill(Color.primaryPastel.opacity(0.3))
                        .frame(height: 12)
                    
                    // Progress
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.accentPastel, Color.primaryPastel],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * (profile?.progress ?? 0), height: 12)
                }
            }
            .frame(height: 12)
            
            // Trimester indicators
            HStack {
                Text("1st Trimester")
                    .font(.system(.caption2, design: .rounded))
                Spacer()
                Text("2nd Trimester")
                    .font(.system(.caption2, design: .rounded))
                Spacer()
                Text("3rd Trimester")
                    .font(.system(.caption2, design: .rounded))
            }
            .foregroundColor(.textPrimary.opacity(0.5))
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Weight Section
    private var weightSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Weight Tracker")
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Button(action: { showAddWeight = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                        Text("Log Weight")
                    }
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.textPrimary)
                    .cornerRadius(20)
                }
            }
            
            if weightEntries.isEmpty {
                // Empty state
                VStack(spacing: 12) {
                    Image(systemName: "scalemass")
                        .font(.system(size: 40))
                        .foregroundColor(.primaryPastel)
                    
                    Text("No weight entries yet")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.6))
                    
                    Text("Track your weight throughout your pregnancy")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.4))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(32)
            } else {
                // Weight summary
                weightSummaryCard
                
                // Weight history
                VStack(spacing: 8) {
                    ForEach(weightEntries.prefix(5), id: \.id) { entry in
                        WeightEntryRow(entry: entry)
                    }
                }
                
                if weightEntries.count > 5 {
                    Text("Showing latest 5 entries")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Weight Summary Card
    private var weightSummaryCard: some View {
        HStack(spacing: 0) {
            // Current weight
            VStack(spacing: 4) {
                Text(weightEntries.first?.weightString ?? "-")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text("Current")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 40)
            
            // Starting weight (from profile)
            VStack(spacing: 4) {
                Text(String(format: "%.1f kg", profile?.weight ?? 0))
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text("Starting")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 40)
            
            // Change
            VStack(spacing: 4) {
                let change = (weightEntries.first?.weight ?? 0) - (profile?.weight ?? 0)
                Text(String(format: "%+.1f kg", change))
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundColor(change >= 0 ? .accentPastel : .orange)
                Text("Change")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.primaryPastel.opacity(0.2))
        .cornerRadius(12)
    }
}

// MARK: - Weight Entry Row
struct WeightEntryRow: View {
    @Environment(\.modelContext) private var modelContext
    let entry: WeightEntry
    
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.weightString)
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Text(entry.dateString)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.5))
            }
            
            Spacer()
            
            if let notes = entry.notes, !notes.isEmpty {
                Text(notes)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.6))
                    .lineLimit(1)
            }
            
            Button(action: { showDeleteConfirmation = true }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.body)
                    .foregroundColor(.textPrimary.opacity(0.3))
            }
        }
        .padding(12)
        .background(Color.backgroundPastel)
        .cornerRadius(10)
        .confirmationDialog("Delete Entry", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                SoundManager.shared.playDeleteSound()
                modelContext.delete(entry)
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

// MARK: - Add Weight Sheet
struct AddWeightSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var weight: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                ZStack {
                    Circle()
                        .fill(Color.accentPastel.opacity(0.3))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "scalemass.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.textPrimary.opacity(0.7))
                }
                .padding(.top, 20)
                
                Text("Log Your Weight")
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                // Weight input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weight (kg)")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundColor(.textPrimary.opacity(0.7))
                    
                    HStack {
                        TextField("0.0", text: $weight)
                            .keyboardType(.decimalPad)
                            .font(.system(.title, design: .rounded, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text("kg")
                            .font(.system(.title3, design: .rounded))
                            .foregroundColor(.textPrimary.opacity(0.6))
                    }
                    .padding()
                    .background(Color.primaryPastel.opacity(0.3))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Notes input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes (optional)")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundColor(.textPrimary.opacity(0.7))
                    
                    TextField("e.g., Morning weight", text: $notes)
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .padding()
                        .background(Color.primaryPastel.opacity(0.3))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Save button
                Button(action: saveWeight) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Save Weight")
                    }
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(weight.isEmpty ? Color.textPrimary.opacity(0.3) : Color.textPrimary)
                    .cornerRadius(14)
                }
                .disabled(weight.isEmpty)
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
    
    private func saveWeight() {
        guard let weightValue = Double(weight) else { return }
        
        let entry = WeightEntry(
            weight: weightValue,
            notes: notes.isEmpty ? nil : notes
        )
        
        modelContext.insert(entry)
        SoundManager.shared.playAddSound()
        dismiss()
    }
}

// MARK: - Edit Profile Sheet
struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var dueDate: Date = Date()
    
    private var profile: UserProfile? {
        profiles.first
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Header
                ZStack {
                    Circle()
                        .fill(Color.primaryPastel.opacity(0.3))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.textPrimary.opacity(0.7))
                }
                .padding(.top, 20)
                
                Text("Edit Profile")
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                VStack(spacing: 16) {
                    // Name
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.textPrimary.opacity(0.7))
                        
                        TextField("Your name", text: $name)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.textPrimary)
                            .padding()
                            .background(Color.primaryPastel.opacity(0.3))
                            .cornerRadius(12)
                    }
                    
                    // Age
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Age")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.textPrimary.opacity(0.7))
                        
                        TextField("Age", text: $age)
                            .keyboardType(.numberPad)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.textPrimary)
                            .padding()
                            .background(Color.primaryPastel.opacity(0.3))
                            .cornerRadius(12)
                    }
                    
                    // Due Date
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Due Date")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.textPrimary.opacity(0.7))
                        
                        DatePicker(
                            "Due Date",
                            selection: $dueDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding()
                        .background(Color.primaryPastel.opacity(0.3))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Save button
                Button(action: saveProfile) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Save Changes")
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
            .onAppear {
                if let profile = profile {
                    name = profile.name
                    age = String(profile.age)
                    dueDate = profile.dueDate
                }
            }
        }
    }
    
    private func saveProfile() {
        guard let profile = profile,
              let ageInt = Int(age) else { return }
        
        profile.name = name
        profile.age = ageInt
        profile.dueDate = dueDate
        
        SoundManager.shared.playCompletionSound()
        dismiss()
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: [UserProfile.self, WeightEntry.self], inMemory: true)
}
