import Foundation

struct BabyWeekInfo {
    let week: Int
    let sizeComparison: String
    let sizeInCm: String
    let weightInGrams: String
    let facts: [String]
    let calmingMessage: String
}

// Comprehensive baby development data for weeks 4-42
let babyDevelopmentData: [Int: BabyWeekInfo] = [
    4: BabyWeekInfo(
        week: 4,
        sizeComparison: "a poppy seed",
        sizeInCm: "0.1 cm",
        weightInGrams: "< 1 g",
        facts: [
            "The embryo is now implanting in your uterine wall.",
            "The amniotic sac and fluid are forming around baby.",
            "The placenta is beginning to develop."
        ],
        calmingMessage: "Your journey has just begun. Every great adventure starts with a single step."
    ),
    5: BabyWeekInfo(
        week: 5,
        sizeComparison: "a sesame seed",
        sizeInCm: "0.2 cm",
        weightInGrams: "< 1 g",
        facts: [
            "Baby's heart is starting to form and will soon beat.",
            "The neural tube (future brain and spine) is developing.",
            "Tiny buds for arms and legs are appearing."
        ],
        calmingMessage: "Amazing things are happening inside you. Trust your body's wisdom."
    ),
    6: BabyWeekInfo(
        week: 6,
        sizeComparison: "a lentil",
        sizeInCm: "0.4 cm",
        weightInGrams: "< 1 g",
        facts: [
            "Baby's heart is now beating about 110 times per minute!",
            "Facial features are beginning to form.",
            "The digestive and respiratory systems are starting to develop."
        ],
        calmingMessage: "A tiny heart beats within you. You're doing wonderfully."
    ),
    7: BabyWeekInfo(
        week: 7,
        sizeComparison: "a blueberry",
        sizeInCm: "1 cm",
        weightInGrams: "< 1 g",
        facts: [
            "Baby's brain is growing rapidly.",
            "Arm and leg buds are getting longer.",
            "The umbilical cord is now fully formed."
        ],
        calmingMessage: "Your baby is growing stronger every day, and so are you."
    ),
    8: BabyWeekInfo(
        week: 8,
        sizeComparison: "a kidney bean",
        sizeInCm: "1.6 cm",
        weightInGrams: "1 g",
        facts: [
            "Baby's fingers and toes are starting to form.",
            "The taste buds are developing.",
            "Baby is starting to move, though you can't feel it yet."
        ],
        calmingMessage: "Every day brings new development. Rest well and nourish yourself."
    ),
    9: BabyWeekInfo(
        week: 9,
        sizeComparison: "a grape",
        sizeInCm: "2.3 cm",
        weightInGrams: "2 g",
        facts: [
            "Baby's basic body structure is complete.",
            "The heart has divided into four chambers.",
            "Tiny teeth are forming under the gums."
        ],
        calmingMessage: "You're almost through the first trimester. You're stronger than you know."
    ),
    10: BabyWeekInfo(
        week: 10,
        sizeComparison: "a kumquat",
        sizeInCm: "3.1 cm",
        weightInGrams: "4 g",
        facts: [
            "Baby is officially a fetus now!",
            "Vital organs are fully formed and starting to function.",
            "Fingernails and toenails are beginning to develop."
        ],
        calmingMessage: "A major milestone reached! Your baby is growing beautifully."
    ),
    11: BabyWeekInfo(
        week: 11,
        sizeComparison: "a fig",
        sizeInCm: "4.1 cm",
        weightInGrams: "7 g",
        facts: [
            "Baby can now open and close their fists.",
            "Tooth buds are appearing under the gums.",
            "Hair follicles are forming."
        ],
        calmingMessage: "Your little one is becoming more active every day. Rest when you need to."
    ),
    12: BabyWeekInfo(
        week: 12,
        sizeComparison: "a lime",
        sizeInCm: "5.4 cm",
        weightInGrams: "14 g",
        facts: [
            "Baby's reflexes are developing.",
            "The kidneys are starting to produce urine.",
            "You might hear the heartbeat at your checkup!"
        ],
        calmingMessage: "End of the first trimester! You've done amazingly well."
    ),
    13: BabyWeekInfo(
        week: 13,
        sizeComparison: "a pea pod",
        sizeInCm: "7.4 cm",
        weightInGrams: "23 g",
        facts: [
            "Baby's fingerprints are forming.",
            "Vocal cords are developing.",
            "Baby can put their thumb in their mouth."
        ],
        calmingMessage: "Welcome to the second trimester! Many mothers feel more energetic now."
    ),
    14: BabyWeekInfo(
        week: 14,
        sizeComparison: "a lemon",
        sizeInCm: "8.7 cm",
        weightInGrams: "43 g",
        facts: [
            "Baby is practicing breathing movements.",
            "The roof of the mouth is fully formed.",
            "Baby can squint, frown, and make faces."
        ],
        calmingMessage: "Your baby is becoming more expressive. Enjoy this special time."
    ),
    15: BabyWeekInfo(
        week: 15,
        sizeComparison: "an apple",
        sizeInCm: "10.1 cm",
        weightInGrams: "70 g",
        facts: [
            "Baby is sensitive to light.",
            "Bones are getting harder.",
            "Baby may be sucking their thumb."
        ],
        calmingMessage: "Every week brings wonderful new developments. You're doing great!"
    ),
    16: BabyWeekInfo(
        week: 16,
        sizeComparison: "an avocado",
        sizeInCm: "11.6 cm",
        weightInGrams: "100 g",
        facts: [
            "Baby's eyes are moving.",
            "The circulatory system is fully functioning.",
            "You might start feeling baby move soon!"
        ],
        calmingMessage: "Halfway through the second trimester! Celebrate this milestone."
    ),
    17: BabyWeekInfo(
        week: 17,
        sizeComparison: "a turnip",
        sizeInCm: "13 cm",
        weightInGrams: "140 g",
        facts: [
            "Baby's skeleton is changing from cartilage to bone.",
            "The umbilical cord is growing stronger.",
            "Sweat glands are developing."
        ],
        calmingMessage: "Your baby is getting stronger. Remember to stay hydrated."
    ),
    18: BabyWeekInfo(
        week: 18,
        sizeComparison: "a bell pepper",
        sizeInCm: "14.2 cm",
        weightInGrams: "190 g",
        facts: [
            "Baby's ears are in their final position.",
            "Baby can hear sounds now!",
            "Myelin is forming around nerves."
        ],
        calmingMessage: "Your baby can hear your voice now. Talk and sing to them!"
    ),
    19: BabyWeekInfo(
        week: 19,
        sizeComparison: "a mango",
        sizeInCm: "15.3 cm",
        weightInGrams: "240 g",
        facts: [
            "Baby's skin is developing a protective coating called vernix.",
            "Brain areas for senses are developing rapidly.",
            "Baby is developing a sleep schedule."
        ],
        calmingMessage: "Almost halfway there! Your body is doing incredible work."
    ),
    20: BabyWeekInfo(
        week: 20,
        sizeComparison: "a banana",
        sizeInCm: "16.4 cm",
        weightInGrams: "300 g",
        facts: [
            "You're halfway through your pregnancy!",
            "Baby can taste what you eat through amniotic fluid.",
            "You might feel definite kicks now."
        ],
        calmingMessage: "HALFWAY MILESTONE! You've come so far. Be proud of yourself."
    ),
    21: BabyWeekInfo(
        week: 21,
        sizeComparison: "a carrot",
        sizeInCm: "26.7 cm",
        weightInGrams: "360 g",
        facts: [
            "Baby's movements are more coordinated.",
            "Eyebrows and eyelids are fully formed.",
            "Baby is swallowing amniotic fluid for practice."
        ],
        calmingMessage: "Your baby is becoming more active. Enjoy feeling those movements!"
    ),
    22: BabyWeekInfo(
        week: 22,
        sizeComparison: "a papaya",
        sizeInCm: "27.8 cm",
        weightInGrams: "430 g",
        facts: [
            "Baby's sense of touch is developing.",
            "Lips and eyelids are more defined.",
            "Baby is developing a sleep cycle."
        ],
        calmingMessage: "Your little one is growing steadily. Take time to rest and bond."
    ),
    23: BabyWeekInfo(
        week: 23,
        sizeComparison: "a grapefruit",
        sizeInCm: "28.9 cm",
        weightInGrams: "500 g",
        facts: [
            "Baby's hearing is improving rapidly.",
            "Lungs are developing surfactant.",
            "Baby may respond to loud sounds."
        ],
        calmingMessage: "Play music for your baby! They can hear it now."
    ),
    24: BabyWeekInfo(
        week: 24,
        sizeComparison: "a corn on the cob",
        sizeInCm: "30 cm",
        weightInGrams: "600 g",
        facts: [
            "Baby's face is almost fully formed.",
            "Taste buds are developing.",
            "Baby has regular sleep and wake cycles."
        ],
        calmingMessage: "A big milestone! Baby is considered viable now. You're doing wonderfully."
    ),
    25: BabyWeekInfo(
        week: 25,
        sizeComparison: "a rutabaga",
        sizeInCm: "34.6 cm",
        weightInGrams: "660 g",
        facts: [
            "Baby's skin is becoming less translucent.",
            "Hair is growing and has color.",
            "Baby responds to your voice."
        ],
        calmingMessage: "Your voice is your baby's favorite sound. Keep talking to them!"
    ),
    26: BabyWeekInfo(
        week: 26,
        sizeComparison: "a zucchini",
        sizeInCm: "35.6 cm",
        weightInGrams: "760 g",
        facts: [
            "Baby's eyes are opening.",
            "Brain waves are more active.",
            "Baby is practicing breathing."
        ],
        calmingMessage: "Third trimester is approaching! You're in the home stretch."
    ),
    27: BabyWeekInfo(
        week: 27,
        sizeComparison: "a cauliflower",
        sizeInCm: "36.6 cm",
        weightInGrams: "875 g",
        facts: [
            "Baby can open and close their eyes.",
            "Brain is very active now.",
            "Baby may have hiccups that you can feel!"
        ],
        calmingMessage: "Welcome to the third trimester! The final chapter of this beautiful journey."
    ),
    28: BabyWeekInfo(
        week: 28,
        sizeComparison: "an eggplant",
        sizeInCm: "37.6 cm",
        weightInGrams: "1 kg",
        facts: [
            "Baby can dream now!",
            "Eyelashes have grown.",
            "Baby is gaining weight quickly."
        ],
        calmingMessage: "Your baby weighs about 1 kg now! Growing so beautifully."
    ),
    29: BabyWeekInfo(
        week: 29,
        sizeComparison: "a butternut squash",
        sizeInCm: "38.6 cm",
        weightInGrams: "1.15 kg",
        facts: [
            "Baby's muscles and lungs are maturing.",
            "Brain is developing billions of neurons.",
            "Baby can regulate their own body temperature."
        ],
        calmingMessage: "Your baby's brain is developing rapidly. Rest and eat well."
    ),
    30: BabyWeekInfo(
        week: 30,
        sizeComparison: "a cabbage",
        sizeInCm: "39.9 cm",
        weightInGrams: "1.3 kg",
        facts: [
            "Baby's bone marrow is making red blood cells.",
            "Vision is developing, can track light.",
            "Baby is getting stronger every day."
        ],
        calmingMessage: "10 weeks to go! You're handling this beautifully."
    ),
    31: BabyWeekInfo(
        week: 31,
        sizeComparison: "a coconut",
        sizeInCm: "41.1 cm",
        weightInGrams: "1.5 kg",
        facts: [
            "Baby's brain connections are forming rapidly.",
            "All five senses are working.",
            "Baby moves about 10 times every 2 hours."
        ],
        calmingMessage: "Count those kicks! Each one is a hello from your baby."
    ),
    32: BabyWeekInfo(
        week: 32,
        sizeComparison: "a squash",
        sizeInCm: "42.4 cm",
        weightInGrams: "1.7 kg",
        facts: [
            "Baby's toenails and fingernails are fully formed.",
            "Baby practices breathing regularly.",
            "Skin is less wrinkled as fat develops."
        ],
        calmingMessage: "8 weeks to go! Your baby is getting ready to meet you."
    ),
    33: BabyWeekInfo(
        week: 33,
        sizeComparison: "a pineapple",
        sizeInCm: "43.7 cm",
        weightInGrams: "1.9 kg",
        facts: [
            "Baby's bones are hardening.",
            "Baby may be settling into a head-down position.",
            "Brain development continues rapidly."
        ],
        calmingMessage: "Your baby is almost fully developed. You're so close!"
    ),
    34: BabyWeekInfo(
        week: 34,
        sizeComparison: "a cantaloupe",
        sizeInCm: "45 cm",
        weightInGrams: "2.1 kg",
        facts: [
            "Baby's central nervous system is maturing.",
            "Lungs are well developed.",
            "Baby recognizes familiar voices."
        ],
        calmingMessage: "Baby knows your voice! Keep talking and singing."
    ),
    35: BabyWeekInfo(
        week: 35,
        sizeComparison: "a honeydew melon",
        sizeInCm: "46.2 cm",
        weightInGrams: "2.4 kg",
        facts: [
            "Baby's kidneys are fully developed.",
            "Most internal systems are ready.",
            "Baby is gaining about 230g per week."
        ],
        calmingMessage: "5 weeks to go! Your body has done amazing work."
    ),
    36: BabyWeekInfo(
        week: 36,
        sizeComparison: "a romaine lettuce",
        sizeInCm: "47.4 cm",
        weightInGrams: "2.6 kg",
        facts: [
            "Baby is considered early term now.",
            "Baby may drop lower in your pelvis.",
            "Bones remain soft for birth."
        ],
        calmingMessage: "You're officially in the home stretch! Get lots of rest."
    ),
    37: BabyWeekInfo(
        week: 37,
        sizeComparison: "a winter melon",
        sizeInCm: "48.6 cm",
        weightInGrams: "2.9 kg",
        facts: [
            "Baby is considered full term!",
            "Baby is practicing breathing and swallowing.",
            "Fat layers continue to build."
        ],
        calmingMessage: "Full term! Baby could arrive any time now. You're ready!"
    ),
    38: BabyWeekInfo(
        week: 38,
        sizeComparison: "a leek",
        sizeInCm: "49.8 cm",
        weightInGrams: "3.1 kg",
        facts: [
            "Baby's brain and lungs continue to mature.",
            "Baby has a firm grasp.",
            "All organs are ready for life outside."
        ],
        calmingMessage: "Any day now! Trust your body and your baby."
    ),
    39: BabyWeekInfo(
        week: 39,
        sizeComparison: "a watermelon",
        sizeInCm: "50.7 cm",
        weightInGrams: "3.3 kg",
        facts: [
            "Baby's brain is still developing rapidly.",
            "Baby is ready to meet you!",
            "Placenta continues providing antibodies."
        ],
        calmingMessage: "You've carried your baby with such love. The wait is almost over."
    ),
    40: BabyWeekInfo(
        week: 40,
        sizeComparison: "a small pumpkin",
        sizeInCm: "51.2 cm",
        weightInGrams: "3.5 kg",
        facts: [
            "Baby is fully developed and ready for birth!",
            "Average baby weighs about 3.5 kg.",
            "Baby will continue getting antibodies during birth."
        ],
        calmingMessage: "Due date! Your baby will come when ready. You've done beautifully."
    ),
    41: BabyWeekInfo(
        week: 41,
        sizeComparison: "a small pumpkin",
        sizeInCm: "51.5 cm",
        weightInGrams: "3.6 kg",
        facts: [
            "Baby is still healthy and growing.",
            "Many babies arrive after their due date.",
            "Your doctor is monitoring everything closely."
        ],
        calmingMessage: "Still waiting? Your baby is just getting a few extra snuggles inside."
    ),
    42: BabyWeekInfo(
        week: 42,
        sizeComparison: "a small pumpkin",
        sizeInCm: "51.7 cm",
        weightInGrams: "3.7 kg",
        facts: [
            "Baby is fully ready for birth.",
            "Your healthcare team is watching closely.",
            "Some babies just need a little more time."
        ],
        calmingMessage: "Almost there! Your baby will arrive very soon. Stay calm and rest."
    )
]

// Helper function to get baby info for a specific week
func getBabyInfo(for week: Int) -> BabyWeekInfo {
    // Clamp week to valid range
    let clampedWeek = max(4, min(42, week))
    
    // Return data for the week, or create a default if somehow missing
    return babyDevelopmentData[clampedWeek] ?? BabyWeekInfo(
        week: clampedWeek,
        sizeComparison: "growing beautifully",
        sizeInCm: "varies",
        weightInGrams: "varies",
        facts: ["Your baby is developing perfectly."],
        calmingMessage: "Every pregnancy is unique and beautiful."
    )
}


