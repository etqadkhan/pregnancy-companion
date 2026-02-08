# Pregnancy Companion 🤰

A gentle, beautifully designed iOS app to help expecting mothers through their pregnancy journey with daily reminders, nutrition tracking, mood journaling, doctor visit management, and baby development tracking.

---

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Requirements](#requirements)
- [Installation & Setup](#installation--setup)
- [Re-running After 7 Days](#re-running-after-7-days)
- [Gemini API Setup](#gemini-api-setup)
- [App Screens Overview](#app-screens-overview)
- [Data Models](#data-models)
- [Notifications System](#notifications-system)
- [Color Palette](#color-palette)
- [Troubleshooting](#troubleshooting)
- [Data Privacy](#data-privacy)

---

## Features

### Daily Task Reminders
- Set customizable reminders for medicines, meals, vitamins, and self-care
- Intelligent hourly "nudge" notifications until tasks are marked complete
- Notifications respect quiet hours (11 PM - 7 AM)
- Tasks automatically reset each day
- Quick-action buttons to mark tasks done from the notification

### AI-Powered Food Logging
- Log meals with natural language descriptions
- AI nutrition analysis using Google Gemini 2.0 Flash
- Tracks protein, fiber, and calories
- Pregnancy-specific daily goals (75g protein, 28g fiber)
- Support for custom protein powder information
- Manual entry option when offline

### Doctor Visit Calendar
- Visual calendar with appointment indicators
- Log appointments with:
  - Weight at visit
  - Blood pressure readings
  - Doctor's notes
  - Injections/medications given
- Automatic reminders (day before at 9 AM + day of at 7 AM)
- Edit and delete past visits

### Baby Development Tracker
- Week-by-week pregnancy progress (weeks 4-42)
- Visual progress bar
- Baby size comparisons (e.g., "size of a mango")
- Developmental facts for each week
- Calming, encouraging messages
- Days remaining countdown

### Mood Journal
- Daily check-ins with 5 categories:
  - Comfort level
  - Sleep quality
  - Diet/appetite
  - Mood
  - Energy level
- Emoji-based intuitive interface
- Historical mood tracking
- Pattern identification

### Profile Management
- Store personal information (name, age, weight)
- Due date calculation
- Current week auto-calculation
- Editable settings

---

## Technology Stack

| Technology | Purpose |
|------------|---------|
| **Swift 5.9+** | Primary programming language |
| **SwiftUI** | Declarative UI framework |
| **SwiftData** | Persistent data storage (Apple's modern ORM) |
| **UserNotifications** | Local push notifications |
| **Google Gemini API** | AI-powered food nutrition analysis |
| **Async/Await** | Modern concurrency for network calls |
| **Combine** | Reactive programming for notification handling |

### Key Frameworks Used

```
- SwiftUI (UI)
- SwiftData (Persistence)
- UserNotifications (Notifications)
- Foundation (Core utilities)
- Combine (Reactive patterns)
```

---

## Architecture

```
PregnancyCompanion/
├── PregnancyCompanionApp.swift    # App entry point, ModelContainer setup
├── ContentView.swift              # Root view with tab navigation
├── Models/
│   ├── UserProfile.swift          # User data model
│   ├── TodoTask.swift             # Task/reminder model
│   ├── FoodEntry.swift            # Meal log model
│   ├── DoctorVisit.swift          # Appointment model
│   ├── MoodEntry.swift            # Mood check-in model
│   └── WeightEntry.swift          # Weight tracking model
├── Views/
│   ├── Today/
│   │   ├── TodayView.swift        # Daily tasks screen
│   │   └── AddTaskSheet.swift     # New task creation
│   ├── Food/
│   │   ├── FoodLogView.swift      # Meal logging screen
│   │   └── AddFoodSheet.swift     # New meal entry
│   ├── Calendar/
│   │   ├── CalendarView.swift     # Appointment calendar
│   │   └── DoctorVisitSheet.swift # Appointment details
│   ├── Baby/
│   │   └── BabyTrackerView.swift  # Baby development screen
│   ├── Mood/
│   │   └── MoodView.swift         # Mood journal screen
│   ├── Profile/
│   │   └── ProfileView.swift      # User settings
│   └── Onboarding/
│       └── OnboardingView.swift   # First-launch setup
├── Services/
│   ├── GeminiService.swift        # AI nutrition API
│   ├── NotificationManager.swift  # Push notification handling
│   └── SoundManager.swift         # Audio feedback
├── Data/
│   └── BabyData.swift             # Week-by-week baby info
├── Utilities/
│   └── Extensions.swift           # Color palette, helpers
└── Assets.xcassets/               # Images, colors, app icon
```

### Design Patterns

- **Singleton Pattern**: `GeminiService.shared`, `NotificationManager.shared`
- **MVVM-ish**: Views with `@Query` for data binding
- **Dependency Injection**: `@Environment(\.modelContext)`
- **Observer Pattern**: Notification handling with Combine

---

## Requirements

| Requirement | Version |
|-------------|---------|
| macOS | 13.0+ (Ventura or later) |
| Xcode | 15.0+ |
| iOS | 17.0+ |
| iPhone | Any iPhone supporting iOS 17 |
| Apple ID | Free or paid developer account |

---

## Installation & Setup

### Step 1: Clone/Download the Project

```bash
cd ~/Downloads
# Navigate to the project folder
cd todo_bot/PregnancyCompanion
```

### Step 2: Open in Xcode

```bash
open PregnancyCompanion.xcodeproj
```

Or double-click `PregnancyCompanion.xcodeproj` in Finder.

### Step 3: Configure Signing

1. Click on the **project file** (blue icon) in Xcode's navigator
2. Select the **"PregnancyCompanion"** target
3. Go to **"Signing & Capabilities"** tab
4. Check **"Automatically manage signing"**
5. Select your **Team** (sign in with Apple ID if needed)
6. Let Xcode create a provisioning profile

### Step 4: Connect Your iPhone

1. Connect iPhone to Mac via USB cable
2. Tap **"Trust"** when prompted on iPhone
3. Select your iPhone from Xcode's device dropdown (top toolbar)

### Step 5: Trust Developer on iPhone

After first install:
1. Go to **Settings → General → VPN & Device Management**
2. Find your Apple ID under "Developer App"
3. Tap **"Trust"**

### Step 6: Build and Run

1. Press **⌘R** or click the **Play button (▶)**
2. Wait for compilation
3. App launches on your iPhone

---

## Re-running After 7 Days

> **Why 7 days?** Free Apple Developer accounts create provisioning profiles that expire after **7 days**. After expiration, the app will crash on launch with a message like "The app could not be verified."

### How to Reinstall After Expiration

#### Method 1: Just Rebuild (Recommended)

1. **Connect your iPhone** to your Mac
2. **Open the project** in Xcode
3. **Select your iPhone** as the run destination
4. **Press ⌘R** (or click Play button)
5. Xcode automatically creates a new 7-day provisioning profile
6. The app is reinstalled and works again

> **Note**: Your data is preserved! SwiftData stores data locally and persists across reinstalls.

#### Method 2: If You Get Signing Errors

1. Go to **Signing & Capabilities** in Xcode
2. Uncheck then re-check **"Automatically manage signing"**
3. Select your Team again
4. Clean build: **Product → Clean Build Folder** (⌘⇧K)
5. Build again: **⌘R**

#### Method 3: Delete and Reinstall

If issues persist:
1. Delete the app from your iPhone
2. In Xcode: **Product → Clean Build Folder**
3. Build and run again

### Tips for Long-Term Use

| Option | Cost | Profile Duration |
|--------|------|------------------|
| Free Apple ID | $0 | 7 days (re-sign weekly) |
| Apple Developer Program | $99/year | 1 year |

With a **paid Apple Developer account** ($99/year), provisioning profiles last **1 year** and you won't need to re-sign weekly.

---

## Gemini API Setup

The food analysis feature uses Google's Gemini AI. Setup is optional - you can use manual entry without it.

### Get Your API Key

1. Go to [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with Google account
3. Click **"Create API Key"**
4. Copy the key

### Configure in App

1. Open the app on your iPhone
2. Go to **Food Log** tab
3. Tap the **gear icon** (⚙️)
4. Paste your API key
5. Optionally add custom protein powder info
6. Tap **Save**

### Usage Limits

- **Free tier**: 60 requests/minute
- Each food entry = 1 API call
- Responses are cached per meal

---

## App Screens Overview

### 1. Onboarding
First launch collects:
- Name
- Age
- Current weight
- Due date (or weeks pregnant)

Creates default reminder tasks automatically.

### 2. Today Tab
- Shows all daily reminders
- Tap checkbox to complete (stops nudges)
- Add new tasks with **+** button
- Tasks reset at midnight

### 3. Food Log Tab
- **"+ Log Meal"** to add food
- AI analyzes nutrition automatically
- Progress bars for daily goals
- Gear icon for API settings

### 4. Calendar Tab
- Monthly view with dots for appointments
- Tap date to add/view visits
- Long-press for quick actions

### 5. Baby Tab
- Current week prominently displayed
- Progress bar (Week 1 → Week 40)
- Size comparison with emoji
- Development facts
- Encouraging message
- Due date countdown

### 6. Profile Tab
- View/edit personal info
- Update due date
- Reset app data

---

## Data Models

### UserProfile
```swift
- name: String
- age: Int
- weight: Double
- dueDate: Date
- createdAt: Date
```

### TodoTask
```swift
- id: UUID
- title: String
- reminderTime: Date
- isActive: Bool
- isCompletedToday: Bool
- lastCompletedDate: Date?
```

### FoodEntry
```swift
- id: UUID
- name: String
- protein: Double
- fiber: Double
- calories: Double
- timestamp: Date
```

### DoctorVisit
```swift
- id: UUID
- date: Date
- weight: Double?
- notes: String
- injections: String?
- bloodPressure: String?
```

### MoodEntry
```swift
- id: UUID
- date: Date
- comfort: Int (1-5)
- sleep: Int (1-5)
- diet: Int (1-5)
- mood: Int (1-5)
- energy: Int (1-5)
```

---

## Notifications System

### Task Reminders
- **Main reminder**: At scheduled time
- **Nudges**: Every hour after until completed
- **Quiet hours**: No nudges 11 PM - 7 AM
- **Actions**: "Done ✓" and "Remind in 30 min"

### Doctor Appointments
- **Day before**: 9:00 AM
- **Day of**: 7:00 AM

### Permission Required
Grant notification permission when prompted for reminders to work.

---

## Color Palette

The app uses a soft, calming pastel palette:

| Color | RGB | Usage |
|-------|-----|-------|
| Primary (Lavender) | `rgb(230, 224, 248)` | Buttons, highlights |
| Secondary (Blush) | `rgb(255, 228, 230)` | Secondary elements |
| Accent (Sage) | `rgb(209, 231, 221)` | Progress, accents |
| Background | `rgb(254, 254, 254)` | App background |
| Text | `rgb(74, 74, 74)` | All text |
| Soft Peach | `rgb(255, 218, 193)` | Baby card accents |
| Soft Blue | `rgb(214, 234, 248)` | Calendar, due date |

---

## Troubleshooting

### App won't build
- Ensure Xcode 15+
- iOS deployment target = 17.0
- **Product → Clean Build Folder** (⌘⇧K)
- Delete `~/Library/Developer/Xcode/DerivedData`

### Can't install on iPhone
- iPhone unlocked and trusted
- Developer profile trusted in Settings
- Correct team selected in Signing

### "App could not be verified" error
- Profile expired (7-day limit)
- Rebuild in Xcode (creates new profile)

### Notifications not appearing
- Settings → PregnancyCompanion → Notifications → ON
- Check Focus mode isn't blocking
- Ensure "Allow" was tapped at first launch

### Food analysis failing
- Check API key is correct
- Verify internet connection
- Wait between requests (rate limits)
- Try manual entry as fallback

### Data seems lost
- Data persists locally via SwiftData
- Reinstalling preserves data
- Only deleting the app removes data

---

## Data Privacy

**All data stays on your device.**

### What's stored locally:
- Profile information
- Tasks and completion history
- Food logs with nutrition data
- Doctor visit records
- Mood entries

### What's sent externally:
- **Food descriptions only** → Gemini API (if enabled)
- No personal data is transmitted
- No analytics or tracking

### Data location:
```
~/Library/Containers/com.yourteam.PregnancyCompanion/
```

---

## Quick Reference Commands

| Action | Shortcut |
|--------|----------|
| Build & Run | ⌘R |
| Stop | ⌘. |
| Clean Build | ⌘⇧K |
| Show Navigator | ⌘1 |
| Show Inspector | ⌘⌥0 |

---

## Support

This app was crafted with love for expecting mothers. Feel free to customize the code to fit your needs!

