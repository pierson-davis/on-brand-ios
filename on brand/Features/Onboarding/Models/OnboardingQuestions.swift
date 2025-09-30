//
//  OnboardingQuestions.swift
//  era
//

import Foundation

enum OnboardingQuestionSet: String, CaseIterable {
    case vibeDiscovery
    case maleVibeDiscovery
    case femaleVibeDiscovery
}

struct OnboardingQuestionBank {
    static func questions(for set: OnboardingQuestionSet) -> [QuizQuestion] {
        switch set {
        case .vibeDiscovery:
            return vibeDiscovery
        case .maleVibeDiscovery:
            return maleVibeDiscovery
        case .femaleVibeDiscovery:
            return femaleVibeDiscovery
        }
    }

    private static let vibeDiscovery: [QuizQuestion] = [
        QuizQuestion(
            prompt: "What are you here for right now?",
            answers: [
                QuizAnswer(text: "Keep my vibe, fresh pics",
                           weights: [.mainCharacter: 2, .glowGetter: 2]),
                QuizAnswer(text: "Reinvent my look",
                           weights: [.chicRebel: 3, .boldVisionary: 1]),
                QuizAnswer(text: "Explore new aesthetics",
                           weights: [.adventureSeeker: 2, .dreamyMuse: 2]),
                QuizAnswer(text: "Just for fun",
                           weights: [.playfulSprite: 3, .cozyChic: 1])
            ]
        ),
        QuizQuestion(
            prompt: "In a group you’re usually…",
            answers: [
                QuizAnswer(text: "The photographer",
                           weights: [.mainCharacter: 2, .socialButterfly: 1]),
                QuizAnswer(text: "The cozy corner friend",
                           weights: [.cozyChic: 2, .sereneSoul: 2]),
                QuizAnswer(text: "The party starter",
                           weights: [.boldVisionary: 2, .playfulSprite: 1]),
                QuizAnswer(text: "The plan maker",
                           weights: [.adventureSeeker: 2, .glowGetter: 1])
            ]
        ),
        QuizQuestion(
            prompt: "Pick a visual pull",
            answers: [
                QuizAnswer(text: "Neutrals & light",
                           weights: [.cozyChic: 2, .sereneSoul: 2]),
                QuizAnswer(text: "Neon & glitter",
                           weights: [.boldVisionary: 2, .playfulSprite: 2]),
                QuizAnswer(text: "Moody & shadowy",
                           weights: [.mysteryIcon: 2, .chicRebel: 2]),
                QuizAnswer(text: "Nature & horizons",
                           weights: [.adventureSeeker: 2, .dreamyMuse: 1])
            ]
        ),
        QuizQuestion(
            prompt: "What do you want your dumps to say?",
            answers: [
                QuizAnswer(text: "I’m glowing & thriving",
                           weights: [.glowGetter: 3, .mainCharacter: 1]),
                QuizAnswer(text: "I’m mysterious — don’t decode me",
                           weights: [.mysteryIcon: 3, .chicRebel: 1]),
                QuizAnswer(text: "I’m the life of the party",
                           weights: [.socialButterfly: 2, .boldVisionary: 2]),
                QuizAnswer(text: "I’m calm & grounded",
                           weights: [.sereneSoul: 2, .dreamyMuse: 1])
            ]
        )
    ]
    
    private static let maleVibeDiscovery: [QuizQuestion] = [
        QuizQuestion(
            prompt: "What's your main goal right now?",
            answers: [
                QuizAnswer(text: "Level up my style game",
                           weights: [.alphaVibe: 2, .charismaticLeader: 2]),
                QuizAnswer(text: "Find my authentic vibe",
                           weights: [.streetSage: 3, .ruggedGentleman: 1]),
                QuizAnswer(text: "Explore new aesthetics",
                           weights: [.urbanExplorer: 2, .creativeGenius: 2]),
                QuizAnswer(text: "Keep it simple and clean",
                           weights: [.minimalistMaven: 3, .zenMaster: 1])
            ]
        ),
        QuizQuestion(
            prompt: "In a group setting, you're usually...",
            answers: [
                QuizAnswer(text: "The natural leader",
                           weights: [.alphaVibe: 3, .charismaticLeader: 2]),
                QuizAnswer(text: "The quiet observer",
                           weights: [.streetSage: 2, .zenMaster: 2]),
                QuizAnswer(text: "The creative one",
                           weights: [.creativeGenius: 3, .techTitan: 1]),
                QuizAnswer(text: "The social connector",
                           weights: [.socialMagnet: 2, .urbanExplorer: 1])
            ]
        ),
        QuizQuestion(
            prompt: "Pick your ideal aesthetic",
            answers: [
                QuizAnswer(text: "Clean minimalism",
                           weights: [.minimalistMaven: 3, .zenMaster: 1]),
                QuizAnswer(text: "Streetwear & urban",
                           weights: [.streetSage: 2, .urbanExplorer: 2]),
                QuizAnswer(text: "Tech & innovation",
                           weights: [.techTitan: 3, .creativeGenius: 1]),
                QuizAnswer(text: "Vintage & timeless",
                           weights: [.vintageVibes: 2, .ruggedGentleman: 2])
            ]
        ),
        QuizQuestion(
            prompt: "What energy do you want to project?",
            answers: [
                QuizAnswer(text: "Confident and commanding",
                           weights: [.alphaVibe: 3, .charismaticLeader: 1]),
                QuizAnswer(text: "Mysterious and intriguing",
                           weights: [.streetSage: 2, .ruggedGentleman: 2]),
                QuizAnswer(text: "Creative and innovative",
                           weights: [.creativeGenius: 3, .techTitan: 1]),
                QuizAnswer(text: "Calm and grounded",
                           weights: [.zenMaster: 2, .minimalistMaven: 1])
            ]
        ),
        QuizQuestion(
            prompt: "Your ideal weekend involves...",
            answers: [
                QuizAnswer(text: "Leading a group adventure",
                           weights: [.alphaVibe: 2, .charismaticLeader: 2]),
                QuizAnswer(text: "Exploring the city solo",
                           weights: [.urbanExplorer: 3, .streetSage: 1]),
                QuizAnswer(text: "Creating something new",
                           weights: [.creativeGenius: 3, .techTitan: 1]),
                QuizAnswer(text: "Chilling with close friends",
                           weights: [.socialMagnet: 2, .zenMaster: 1])
            ]
        )
    ]
    
    private static let femaleVibeDiscovery: [QuizQuestion] = [
        QuizQuestion(
            prompt: "What are you here for right now?",
            answers: [
                QuizAnswer(text: "Keep my vibe, fresh pics",
                           weights: [.mainCharacter: 2, .glowGetter: 2]),
                QuizAnswer(text: "Reinvent my look",
                           weights: [.chicRebel: 3, .boldVisionary: 1]),
                QuizAnswer(text: "Explore new aesthetics",
                           weights: [.adventureSeeker: 2, .dreamyMuse: 2]),
                QuizAnswer(text: "Just for fun",
                           weights: [.playfulSprite: 3, .cozyChic: 1])
            ]
        ),
        QuizQuestion(
            prompt: "In a group you're usually…",
            answers: [
                QuizAnswer(text: "The photographer",
                           weights: [.mainCharacter: 2, .socialButterfly: 1]),
                QuizAnswer(text: "The cozy corner friend",
                           weights: [.cozyChic: 2, .sereneSoul: 2]),
                QuizAnswer(text: "The party starter",
                           weights: [.boldVisionary: 2, .playfulSprite: 1]),
                QuizAnswer(text: "The plan maker",
                           weights: [.adventureSeeker: 2, .glowGetter: 1])
            ]
        ),
        QuizQuestion(
            prompt: "Pick a visual pull",
            answers: [
                QuizAnswer(text: "Neutrals & light",
                           weights: [.cozyChic: 2, .sereneSoul: 2]),
                QuizAnswer(text: "Neon & glitter",
                           weights: [.boldVisionary: 2, .playfulSprite: 2]),
                QuizAnswer(text: "Moody & shadowy",
                           weights: [.mysteryIcon: 2, .chicRebel: 2]),
                QuizAnswer(text: "Nature & horizons",
                           weights: [.adventureSeeker: 2, .dreamyMuse: 1])
            ]
        ),
        QuizQuestion(
            prompt: "What do you want your dumps to say?",
            answers: [
                QuizAnswer(text: "I'm glowing & thriving",
                           weights: [.glowGetter: 3, .mainCharacter: 1]),
                QuizAnswer(text: "I'm mysterious — don't decode me",
                           weights: [.mysteryIcon: 3, .chicRebel: 1]),
                QuizAnswer(text: "I'm the life of the party",
                           weights: [.socialButterfly: 2, .boldVisionary: 2]),
                QuizAnswer(text: "I'm calm & grounded",
                           weights: [.sereneSoul: 2, .dreamyMuse: 1])
            ]
        )
    ]
}
