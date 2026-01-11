import Foundation
import AudioToolbox
import UIKit

class SoundManager {
    static let shared = SoundManager()
    
    private init() {}
    
    // MARK: - System Sound IDs
    // Common pleasant system sounds
    private enum SystemSound: UInt32 {
        case mailSent = 1001          // Soft swoosh
        case smsReceived = 1003       // Tri-tone
        case calendarAlert = 1005     // Chord
        case lowPower = 1006          // Low power
        case mailReceived = 1000      // Ding
        case newMail = 1007           // New mail
        case tweet = 1016             // Tweet sound
        case anticipate = 1020        // Anticipate
        case bloom = 1021             // Bloom  
        case calypso = 1022           // Calypso
        case chooChoo = 1023          // Choo Choo
        case descent = 1024           // Descent
        case fanfare = 1025           // Fanfare (celebration)
        case ladder = 1026            // Ladder
        case minuet = 1027            // Minuet
        case newsFlash = 1028         // News Flash
        case noir = 1029              // Noir
        case sherwoodForest = 1030    // Sherwood Forest
        case spell = 1031             // Spell
        case suspense = 1032          // Suspense
        case telegraph = 1033         // Telegraph
        case tiptoes = 1034           // Tiptoes
        case typewriters = 1035       // Typewriters
        case update = 1036            // Update
        case paymentSuccess = 1407    // Payment success (soft chime)
        case photoShutter = 1108      // Camera shutter
    }
    
    // MARK: - Play Completion Sound
    /// Plays a pleasant completion sound with haptic feedback
    func playCompletionSound() {
        // Play a soft, pleasant sound
        AudioServicesPlaySystemSound(SystemSound.bloom.rawValue)
        
        // Add haptic feedback
        playSuccessHaptic()
    }
    
    // MARK: - Play Undo Sound  
    /// Plays a sound when task is unmarked/undone
    func playUndoSound() {
        AudioServicesPlaySystemSound(SystemSound.descent.rawValue)
        playLightHaptic()
    }
    
    // MARK: - Play Notification Sound
    /// Plays a gentle notification sound
    func playNotificationSound() {
        AudioServicesPlaySystemSound(SystemSound.calypso.rawValue)
        playMediumHaptic()
    }
    
    // MARK: - Play Error Sound
    /// Plays an error/warning sound
    func playErrorSound() {
        AudioServicesPlaySystemSound(SystemSound.suspense.rawValue)
        playErrorHaptic()
    }
    
    // MARK: - Play Add Sound
    /// Plays a sound when something is added
    func playAddSound() {
        AudioServicesPlaySystemSound(SystemSound.tiptoes.rawValue)
        playLightHaptic()
    }
    
    // MARK: - Play Delete Sound
    /// Plays a sound when something is deleted
    func playDeleteSound() {
        AudioServicesPlaySystemSound(SystemSound.telegraph.rawValue)
        playMediumHaptic()
    }
    
    // MARK: - Haptic Feedback
    
    /// Success haptic (for task completion)
    func playSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    /// Light haptic (for minor actions)
    func playLightHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// Medium haptic (for standard actions)
    func playMediumHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// Heavy haptic (for important actions)
    func playHeavyHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// Error haptic
    func playErrorHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
    
    /// Warning haptic
    func playWarningHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
    }
    
    /// Selection changed haptic
    func playSelectionHaptic() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
