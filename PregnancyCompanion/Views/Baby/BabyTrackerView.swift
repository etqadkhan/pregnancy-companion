import SwiftUI
import SwiftData

struct BabyTrackerView: View {
    @Query private var profiles: [UserProfile]
    
    private var profile: UserProfile? {
        profiles.first
    }
    
    private var currentWeek: Int {
        profile?.currentWeek ?? 20
    }
    
    private var babyInfo: BabyWeekInfo {
        getBabyInfo(for: currentWeek)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Week Progress Card
                    weekProgressCard
                    
                    // Baby Size Card
                    babySizeCard
                    
                    // Development Facts
                    developmentFactsCard
                    
                    // Calming Message
                    calmingMessageCard
                    
                    // Due Date Info
                    dueDateCard
                }
                .padding()
            }
            .background(Color.backgroundPastel)
            .navigationTitle("Your Baby")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Week Progress Card
    private var weekProgressCard: some View {
        VStack(spacing: 16) {
            Text("Week")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.textPrimary.opacity(0.7))
            
            Text("\(currentWeek)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.textPrimary)
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.textPrimary.opacity(0.1))
                        .frame(height: 12)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryPastel, Color.accentPastel],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(profile?.progress ?? 0.5), height: 12)
                }
            }
            .frame(height: 12)
            
            HStack {
                Text("Week 1")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.5))
                Spacer()
                Text("Week 40")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.textPrimary.opacity(0.5))
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Baby Size Card
    private var babySizeCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "ruler")
                    .font(.title3)
                    .foregroundColor(.accentPastel)
                Text("Baby's Size")
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Spacer()
            }
            
            HStack(spacing: 20) {
                // Size comparison icon placeholder
                ZStack {
                    Circle()
                        .fill(Color.softPeach.opacity(0.5))
                        .frame(width: 80, height: 80)
                    
                    Text("👶")
                        .font(.system(size: 40))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("About the size of")
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.6))
                    
                    Text(babyInfo.sizeComparison)
                        .font(.system(.title2, design: .rounded, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: 16) {
                        Label(babyInfo.sizeInCm, systemImage: "arrow.up.and.down")
                            .font(.system(.caption, design: .rounded))
                        Label(babyInfo.weightInGrams, systemImage: "scalemass")
                            .font(.system(.caption, design: .rounded))
                    }
                    .foregroundColor(.textPrimary.opacity(0.7))
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Development Facts Card
    private var developmentFactsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.title3)
                    .foregroundColor(.primaryPastel)
                Text("This Week's Development")
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(babyInfo.facts, id: \.self) { fact in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.secondaryPastel)
                            .padding(.top, 4)
                        
                        Text(fact)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Calming Message Card
    private var calmingMessageCard: some View {
        VStack(spacing: 12) {
            Image(systemName: "leaf.fill")
                .font(.title)
                .foregroundColor(.accentPastel)
            
            Text(babyInfo.calmingMessage)
                .font(.system(.body, design: .rounded, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.textPrimary)
                .padding(.horizontal)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.accentPastel.opacity(0.3), Color.primaryPastel.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
    
    // MARK: - Due Date Card
    private var dueDateCard: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .font(.title3)
                    .foregroundColor(.softBlue)
                Text("Due Date")
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile?.dueDate.formattedDate() ?? "Not set")
                        .font(.system(.title3, design: .rounded, weight: .medium))
                        .foregroundColor(.textPrimary)
                    
                    Text("\(profile?.daysRemaining ?? 0) days to go")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.textPrimary.opacity(0.7))
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.softBlue.opacity(0.3))
                        .frame(width: 60, height: 60)
                    
                    Text("👶")
                        .font(.system(size: 28))
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    BabyTrackerView()
        .modelContainer(for: UserProfile.self, inMemory: true)
}


