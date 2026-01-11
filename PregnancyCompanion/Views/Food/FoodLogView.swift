import SwiftUI
import SwiftData

struct FoodLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FoodEntry.timestamp, order: .reverse) private var allEntries: [FoodEntry]
    
    @State private var showAddFood = false
    @State private var showSettings = false
    
    private var todayEntries: [FoodEntry] {
        allEntries.filter { $0.isToday }
    }
    
    private var totalProtein: Double {
        todayEntries.reduce(0) { $0 + $1.protein }
    }
    
    private var totalFiber: Double {
        todayEntries.reduce(0) { $0 + $1.fiber }
    }
    
    private var totalCalories: Double {
        todayEntries.reduce(0) { $0 + $1.calories }
    }
    
    // Recommended daily values for pregnancy
    private let recommendedProtein: Double = 75 // grams
    private let recommendedFiber: Double = 28 // grams
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Daily Summary Card
                    dailySummaryCard
                    
                    // Today's Meals
                    if !todayEntries.isEmpty {
                        todayMealsSection
                    } else {
                        emptyStateView
                    }
                }
                .padding()
            }
            .background(Color.backgroundPastel)
            .navigationTitle("Food Log")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gearshape")
                                .font(.body)
                                .foregroundColor(.textPrimary)
                        }
                        
                        Button(action: { showAddFood = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.textPrimary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddFood) {
                AddFoodSheet()
            }
            .sheet(isPresented: $showSettings) {
                APISettingsSheet()
            }
        }
    }
    
    // MARK: - Daily Summary Card
    private var dailySummaryCard: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Today's Nutrition")
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Spacer()
                Text(Date().formattedDate())
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.6))
            }
            
            HStack(spacing: 16) {
                // Protein
                nutritionCircle(
                    value: totalProtein,
                    goal: recommendedProtein,
                    label: "Protein",
                    unit: "g",
                    color: .accentPastel
                )
                
                // Fiber
                nutritionCircle(
                    value: totalFiber,
                    goal: recommendedFiber,
                    label: "Fiber",
                    unit: "g",
                    color: .primaryPastel
                )
                
                // Calories (no goal, just display)
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(Color.softPeach.opacity(0.3), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .fill(Color.softPeach.opacity(0.2))
                            .frame(width: 64, height: 64)
                        
                        Text("\(Int(totalCalories))")
                            .font(.system(.body, design: .rounded, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    
                    Text("Calories")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.6))
                }
            }
            
            // Pregnancy tip
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.softPeach)
                Text("During pregnancy, aim for 75g protein and 28g fiber daily")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.7))
            }
            .padding(12)
            .background(Color.softPeach.opacity(0.2))
            .cornerRadius(10)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private func nutritionCircle(value: Double, goal: Double, label: String, unit: String, color: Color) -> some View {
        VStack(spacing: 8) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: min(value / goal, 1.0))
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 0) {
                    Text("\(Int(value))")
                        .font(.system(.body, design: .rounded, weight: .bold))
                        .foregroundColor(.textPrimary)
                    Text("/\(Int(goal))\(unit)")
                        .font(.system(size: 10, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.5))
                }
            }
            
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.textPrimary.opacity(0.6))
        }
    }
    
    // MARK: - Today's Meals Section
    private var todayMealsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Meals")
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundColor(.textPrimary)
                .padding(.leading, 4)
            
            VStack(spacing: 8) {
                ForEach(todayEntries, id: \.id) { entry in
                    FoodEntryRow(entry: entry)
                }
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 48))
                .foregroundColor(.accentPastel)
            
            Text("No meals logged today")
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.textPrimary)
            
            Text("Log what you eat to track your nutrition")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.textPrimary.opacity(0.6))
            
            Button(action: { showAddFood = true }) {
                Text("Log a Meal")
                    .primaryButtonStyle()
            }
        }
        .padding(40)
    }
}

// MARK: - Food Entry Row
struct FoodEntryRow: View {
    @Environment(\.modelContext) private var modelContext
    let entry: FoodEntry
    
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Food icon
            ZStack {
                Circle()
                    .fill(Color.accentPastel.opacity(0.3))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "fork.knife")
                    .font(.body)
                    .foregroundColor(.textPrimary.opacity(0.6))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.foodName)
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                HStack(spacing: 12) {
                    Label("\(Int(entry.protein))g protein", systemImage: "p.circle")
                    Label("\(Int(entry.fiber))g fiber", systemImage: "leaf")
                }
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.textPrimary.opacity(0.5))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(entry.calories))")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Text("cal")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.5))
            }
            
            // Delete button
            Button(action: { showDeleteConfirmation = true }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.body)
                    .foregroundColor(.textPrimary.opacity(0.3))
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        .confirmationDialog("Delete Entry", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                modelContext.delete(entry)
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

// MARK: - API Settings Sheet
struct APISettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var apiKey: String = ""
    @State private var customProteinInfo: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "key.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.primaryPastel)
                    .padding(.top, 20)
                
                Text("API Settings")
                    .font(.system(.title2, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                VStack(spacing: 16) {
                    // API Key
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gemini API Key")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.textPrimary.opacity(0.7))
                        
                        SecureField("Enter your API key", text: $apiKey)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.textPrimary)
                            .padding()
                            .background(Color.primaryPastel.opacity(0.3))
                            .cornerRadius(12)
                        
                        Text("Get your free API key from Google AI Studio")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.textPrimary.opacity(0.5))
                    }
                    
                    // Custom Protein Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Custom Protein Powder Info (Optional)")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.textPrimary.opacity(0.7))
                        
                        TextField("e.g., My protein powder has 25g protein per scoop", text: $customProteinInfo, axis: .vertical)
                            .lineLimit(3...5)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.textPrimary)
                            .padding()
                            .background(Color.primaryPastel.opacity(0.3))
                            .cornerRadius(12)
                        
                        Text("This will be used when analyzing foods with your protein powder")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.textPrimary.opacity(0.5))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: saveSettings) {
                    Text("Save Settings")
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
                apiKey = UserDefaults.standard.string(forKey: "gemini_api_key") ?? ""
                customProteinInfo = UserDefaults.standard.string(forKey: "custom_protein_info") ?? ""
            }
        }
    }
    
    private func saveSettings() {
        if !apiKey.isEmpty {
            GeminiService.shared.setAPIKey(apiKey)
        }
        UserDefaults.standard.set(customProteinInfo, forKey: "custom_protein_info")
        dismiss()
    }
}

#Preview {
    FoodLogView()
        .modelContainer(for: FoodEntry.self, inMemory: true)
}


