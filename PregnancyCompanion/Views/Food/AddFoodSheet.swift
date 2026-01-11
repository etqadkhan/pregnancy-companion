import SwiftUI
import SwiftData

enum FoodEntryMode: String, CaseIterable {
    case justLog = "Just Log It"
    case manual = "Enter Nutrition"
    case ai = "AI Analysis"
}

struct AddFoodSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var foodDescription: String = ""
    @State private var manualProtein: String = ""
    @State private var manualFiber: String = ""
    @State private var manualCalories: String = ""
    @State private var entryMode: FoodEntryMode = .justLog
    
    @State private var isAnalyzing: Bool = false
    @State private var analyzedResult: NutritionInfo?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    ZStack {
                        Circle()
                            .fill(Color.accentPastel.opacity(0.3))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.textPrimary.opacity(0.7))
                    }
                    .padding(.top, 20)
                    
                    Text("Log a Meal")
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    // Food description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What did you eat?")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.textPrimary.opacity(0.7))
                        
                        TextField("e.g., 2 eggs with toast and a glass of milk", text: $foodDescription, axis: .vertical)
                            .lineLimit(3...5)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.textPrimary)
                            .padding()
                            .background(Color.primaryPastel.opacity(0.3))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Entry mode picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How would you like to log it?")
                            .font(.system(.subheadline, design: .rounded, weight: .medium))
                            .foregroundColor(.textPrimary.opacity(0.7))
                            .padding(.horizontal)
                        
                        Picker("Entry Mode", selection: $entryMode) {
                            ForEach(FoodEntryMode.allCases, id: \.self) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                    }
                    
                    // Content based on mode
                    switch entryMode {
                    case .justLog:
                        justLogSection
                    case .manual:
                        manualEntryFields
                    case .ai:
                        aiAnalysisSection
                    }
                    
                    // Error message
                    if let error = errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text(error)
                                .font(.system(.caption, design: .rounded))
                                .foregroundColor(.orange)
                        }
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 40)
                    
                    // Save button
                    Button(action: saveEntry) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Meal")
                        }
                        .font(.system(.body, design: .rounded, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(canSave ? Color.textPrimary : Color.textPrimary.opacity(0.3))
                        .cornerRadius(14)
                    }
                    .disabled(!canSave)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
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
        }
    }
    
    // MARK: - Just Log Section
    private var justLogSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.primaryPastel)
                Text("Quick log - no nutrition tracking needed!")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.7))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.primaryPastel.opacity(0.2))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Text("Perfect for when you just want to remember what you ate without tracking macros.")
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.textPrimary.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
    
    // MARK: - Manual Entry Fields
    private var manualEntryFields: some View {
        VStack(spacing: 16) {
            nutritionField(title: "Protein (g)", value: $manualProtein)
            nutritionField(title: "Fiber (g)", value: $manualFiber)
            nutritionField(title: "Calories", value: $manualCalories)
            
            Text("Enter approximate values - it doesn't have to be exact!")
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.textPrimary.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    private func nutritionField(title: String, value: Binding<String>) -> some View {
        HStack {
            Text(title)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundColor(.textPrimary.opacity(0.7))
            Spacer()
            TextField("0", text: value)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.textPrimary)
                .padding(10)
                .background(Color.white)
                .cornerRadius(8)
        }
        .padding()
        .background(Color.primaryPastel.opacity(0.2))
        .cornerRadius(12)
    }
    
    // MARK: - AI Analysis Section
    private var aiAnalysisSection: some View {
        VStack(spacing: 16) {
            // Analyze button
            Button(action: analyzeFood) {
                HStack {
                    if isAnalyzing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Image(systemName: "sparkles")
                    }
                    Text(isAnalyzing ? "Analyzing..." : "Analyze with AI")
                }
                .font(.system(.body, design: .rounded, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(foodDescription.isEmpty ? Color.primaryPastel.opacity(0.5) : Color.primaryPastel)
                .cornerRadius(12)
            }
            .disabled(foodDescription.isEmpty || isAnalyzing)
            .padding(.horizontal)
            
            // Results
            if let result = analyzedResult {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.accentPastel)
                        Text("Analysis Complete")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundColor(.textPrimary)
                        Spacer()
                    }
                    
                    HStack(spacing: 20) {
                        resultPill(value: result.protein, label: "Protein", unit: "g")
                        resultPill(value: result.fiber, label: "Fiber", unit: "g")
                        resultPill(value: result.calories, label: "Calories", unit: "")
                    }
                }
                .padding()
                .background(Color.accentPastel.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            // Info text
            Text("AI will estimate nutrition based on your description. For more accuracy, include portion sizes.")
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.textPrimary.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
    
    private func resultPill(value: Double, label: String, unit: String) -> some View {
        VStack(spacing: 4) {
            Text("\(Int(value))\(unit)")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundColor(.textPrimary)
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.textPrimary.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Helpers
    private var canSave: Bool {
        guard !foodDescription.isEmpty else { return false }
        
        switch entryMode {
        case .justLog:
            // Just need food description
            return true
        case .manual:
            // Need at least one nutrition value, or allow empty (will default to 0)
            return true
        case .ai:
            // Need AI analysis result
            return analyzedResult != nil
        }
    }
    
    private func analyzeFood() {
        guard !foodDescription.isEmpty else { return }
        
        isAnalyzing = true
        errorMessage = nil
        
        // Get custom protein info if set
        let customInfo = UserDefaults.standard.string(forKey: "custom_protein_info")
        
        Task {
            do {
                let result = try await GeminiService.shared.analyzeFood(foodDescription, customProteinInfo: customInfo)
                await MainActor.run {
                    analyzedResult = result
                    isAnalyzing = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isAnalyzing = false
                }
            }
        }
    }
    
    private func saveEntry() {
        let protein: Double
        let fiber: Double
        let calories: Double
        let isManual: Bool
        
        switch entryMode {
        case .justLog:
            // No nutrition data - just logging the food
            protein = 0
            fiber = 0
            calories = 0
            isManual = true
        case .manual:
            protein = Double(manualProtein) ?? 0
            fiber = Double(manualFiber) ?? 0
            calories = Double(manualCalories) ?? 0
            isManual = true
        case .ai:
            if let result = analyzedResult {
                protein = result.protein
                fiber = result.fiber
                calories = result.calories
                isManual = false
            } else {
                return
            }
        }
        
        let entry = FoodEntry(
            foodName: foodDescription,
            protein: protein,
            fiber: fiber,
            calories: calories,
            isManualEntry: isManual
        )
        
        modelContext.insert(entry)
        dismiss()
    }
}

#Preview {
    AddFoodSheet()
        .modelContainer(for: FoodEntry.self, inMemory: true)
}
